from __future__ import print_function
from getopt import getopt, error
from sys import argv, exit
from os import path, remove
from re import findall, sub, MULTILINE, finditer
from string import ascii_uppercase
import subprocess

# TODO: Works only with the single shot version of clingo encodings!!!
# python test-telingo-result.py -c Visit-all/encoding_single.asp -s Visit-all/0012-visitall-36-1.asp -t Visit-all/telingo-output-0012.txt -o Visit-all/

arr_cmd_args = argv[1:]
unix_opts = "c:s:t:i:d:o:"  
gnu_opts = ["clingo-encoding=", "instance=", "telingo-answers=", "max-answers=", "max-time=", "output-path="] 

clingo_file = ''
test_instance = ''
telingo_answers = ''
output_path = './'
report_file_path = ''
fact_file_path = ''
max_answers = 100
max_time = 10

def check_file_exists(p):
    return path.exists(p) and path.isfile(p)

try:  
    arguments, values = getopt(arr_cmd_args, unix_opts, gnu_opts)

    for a, v in arguments:  
        if a in ("-c", "--clingo-encoding"):
            if v == '' or not check_file_exists(v):
                print("No path to clingo encoding specified")
                exit(1)
            else:
                clingo_file = v
                continue
        if a in ("-s", "--instance"):
            if v == '' or not check_file_exists(v):
                print("No path to test instance specified")
                exit(1)
            else:
                test_instance = v
                tmp = findall("(([a-zA-Z0-9-_]+)(\.(as|l)p))$", v)[0][0]
                report_file_path += sub("\.(as|l)p", "__TEST_REPORT.txt", tmp)
                #print(output_path)
                continue
        if a in ("-t", "--telingo-answers"):
            if v == '' or not check_file_exists(v):
                print("No path to telingo answers specified")
                exit(1)
            else:
                telingo_answers = v
                fact_file_path = sub("([a-zA-Z0-9-_]+)(\.txt$)", r"\1__GENERATED_FACTS_ANSWER_", v)
                continue
        if a in ("-i", "--max-answers"):
            v = int(v)
            if v <= 0:
                print("Only positive integers larger than 0 allowed, using default value: %d" % max_answers)
            else:
                max_answers = int(v)
            continue
        if a in ("-d", "--max-time"):
            v = int(v)
            if v <= 0:
                print("Only positive integers larger than 0 allowed, using default value: %d" % max_time)
            else:
                max_time = int(v)
            continue
        if a in ("-o", "--output-path"):
            if not path.exists(v):
                print("Path '%s' for test report does not exist." % v)
                exit(1)
            else:
                output_path = v
                continue
        else:
            assert False, "Argument not supported"

        # not perfect but check is sufficient

except error as err:  
    # output error, and return with an error code
    print (str(err))
    exit(2)

# read in telingo results file
telingo_file = open(telingo_answers, "r")
if telingo_file.mode == "r":
    telingo_file_contents = telingo_file.read()
    report_msg = []

    print("Checking telingo results ...")

    for i in range(1, max_answers+1):
        regex = r'(Answer:\s{1}' + str(i) + '\n(\s{1}State\s[0-9]+:\n|\s\s[a-zA-Z_]+\([a-zA-Z0-9_\,]+\)\n){1,})'

        # filter specific answer set from output file
        answer = findall(regex, telingo_file_contents, flags=MULTILINE)
        #print(answer)
        if len(answer) == 0:
            continue
        else:
            ## build test string
            # get full text result
            answer = answer[0][0]
            answer = sub('(Answer:\s[0-9]+\n\sState 0:\n)', '', answer)
            answer = sub('\n|\s', '', answer)
            facts = []
            preds = []
            constraints = []


            # create clingo compatible telingo answer predicates
            for match in finditer("(State[0-9]+:)([a-z_]+\([a-zA-Z0-9_,]+\))", answer):
                #print(match.group(2))
                #remove "State"
                time = sub("State", "", match.group(1))
                # remove ":"
                time = sub(":", "", time)
                # add time value to telingo predicate
                pred_telingo = match.group(2)
                pred_telingo = sub("\)", ","+time+").\n", pred_telingo)
                # add postfix string to telingo predicate to mark it as such
                pred_telingo = sub("(^[a-zA-Z_]+)(\([a-zA-Z0-9_,]+\)\.)", r"\1"+"_telingo"+r"\2", pred_telingo)
                facts.append(pred_telingo)

                # get the predicate name and determine the number of arguments (later used to build the integrity constraints)
                pred = match.group(2)
                pred_name = sub("\([a-zA-Z0-9_,]+\)", "", pred)
                pred_num_args = findall(",", pred_telingo)
                pred_num_args = len(pred_num_args) + 1
                
                # no duplicates allowed
                if (pred_name, pred_num_args) not in preds:
                    preds.append((pred_name, pred_num_args))

            # create the integrity constraints (see below)
            '''
            :- not sol_p(X), p(X).
            :- sol_p(X), not p(X).
            '''
            for pred in preds:
                c=""

                args = ""
                for j in range(0,pred[1]):
                    if j < pred[1] - 1:
                        args += ascii_uppercase[j] + ","
                    else:
                        # switch comments to use incmode/single shot version
                        #args += "t"
                        args += ascii_uppercase[j]

                c += ":- not " + pred[0] + "_telingo(" + args + "), " + pred[0] + "(" + args + ").\n"
                c += ":- " + pred[0] + "_telingo(" + args + "), not " + pred[0] + "(" + args + ").\n"
                if c not in constraints:
                    constraints.append(c)

            # create file containing facts and constraints
            fact_file_path_tmp = fact_file_path + str(i) + ".lp"
            fact_file = open(fact_file_path_tmp, "w+")
            for fact in facts:
                fact_file.write(fact)
            # uncomment to use incmode version
            #fact_file.write("#program step(t).\n")
            for constraint in constraints:
                fact_file.write(constraint)

            '''
            print(facts)
            print(' ')
            print(constraints)
            print(' ')
            print(preds)
            '''

            fact_file.close()

            # create clingo command to run tests
            cmd_opts = clingo_file + " " + test_instance + " " + fact_file_path_tmp + " ./incmode.lp 0 --stats --time-limit=" + str(max_time)
            print("Running clingo with: %s" % cmd_opts)
             
            # run generated clingo command
            # incmode version
            #cmd = subprocess.Popen(["clingo", clingo_file, test_instance, fact_file_path_tmp, "./incmode.lp", "0", "--stats", "--time-limit="+str(max_time)], stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
            # single shot version
            cmd = subprocess.Popen(["clingo", clingo_file, test_instance, fact_file_path_tmp, "0", "--stats", "--time-limit="+str(max_time)], stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
            
            # run command and save output and error msg
            stdout, stderr = cmd.communicate()
            
            if stderr == None:
                # save clingo result (if collection of facts and rules are (un)satisfiable)
                #print(findall("((UN)?SATISFIABLE)", stdout))
                msg = "Answer " + str(i) + ": " + findall("((UN)?SATISFIABLE)", stdout)[0][0] + "\n"
                report_msg.append(msg)
            else:
                print(stderr)

            # remove generated fact files
            remove(fact_file_path_tmp)

        # write test results to report file
        report_file = open(output_path + report_file_path, "w+")
        for msg in report_msg:
            report_file.write(msg)

        report_file.close()

    telingo_file.close()
    
    print("DONE")
