echo -----------INICIO-----------
call cd..
call cd robot
echo -----LOOP----
call python -m robot -d ./logs flow_test_case/
call python -m robot -d ./logs flow_test_case/
call python -m robot -d ./logs flow_test_case/
call python -m robot -d ./logs flow_test_case/
call python -m robot -d ./logs flow_test_case/


