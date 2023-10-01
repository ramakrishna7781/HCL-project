#!/bin/bash
logged_in=false
database_file="employee.db"

function create_tables() {
    sqlite3 "$database_file" <<EOF
    PRAGMA foreign_keys = ON;

    CREATE TABLE IF NOT EXISTS employees (
        ID INTEGER PRIMARY KEY,
        Name TEXT NOT NULL,
        Gender TEXT,
        Location TEXT,
        Phone TEXT,
        Email TEXT,
        Education TEXT,
        Designation TEXT,
        Salary INTEGER
    );
EOF
}

function add_employee() {
    while true; do
        read -p "Enter the name of the employee: " empName
        if [[ "$empName" =~ ^[a-zA-Z0-9[:space:]]+$ ]]; then
            break
        else
            echo "INVALID EMPLOYEE NAME. ONLY ALPHANUMERIC CHARACTERS AND SPACES ARE ALLOWED."
        fi
    done
    while true; do
        read -p "Enter the gender of the employee: " empGen
        if [[ "$empGen" =~ ^[Mm][Aa][Ll][Ee]$ || "$empGen" =~ ^[Ff][Ee][Mm][Aa][Ll][Ee]$ ]]; then
            break
        else
            echo "INVALID GENDER. PLEASE ENTER 'MALE' or 'FEMALE'"
        fi
    done
    while true; do
        read -p "Enter the location of the employee: " empLoc
        if [[ -n $empLoc ]]; then
            break
        else
            echo "EMPLOYEE LOCATION CANNOT BE EMPTY"
        fi
    done
    while true; do
        read -p "Enter the phone number of the employee: " empPhn
        if [[ $empPhn =~ ^[0-9]{10}$ ]]; then
            break
        else
            echo "INVALID PHONE NUMBER. PLEASE ENTER A 10-digit NUMERIC VALUE."
        fi
    done
    while true; do
        read -p "Enter the email address of the employee: " empMail
        if [[ $empMail =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$ ]]; then
            break
        else
            echo "INVALID Email ADDRESS FORMAT. PLEASE ENTER A VALID Email ADDRESS."
        fi
    done
    while true; do
        read -p "Enter the education qualification of the employee: " empEdu
        if [[ -n $empEdu ]]; then
            break
        else
            echo "EDUCATION QUALIFICATION CANNOT BE EMPTY."
        fi
    done
    while true; do
        read -p "Enter the designation of the employee: " empRole
        if [[ -n $empRole ]]; then
            break
        else
            echo "EMPLOYEE DESIGNATION CANNOT BE EMPTY."
        fi
    done
    while true; do
        read -p "Enter the salary of the employee: " empSal
        if [[ $empSal =~ ^[1-9][0-9]*$ ]]; then
            break
        else
            echo "INVALID SALAY. PLEASE ENTER A POSITIVE NUMERIC VALUE."
        fi
    done
    sqlite3 "$database_file" <<EOF
    INSERT INTO employees (Name, Gender, Location, Phone, Email, Education, Designation, Salary)
    VALUES ('$empName', '$empGen', '$empLoc', '$empPhn', '$empMail', '$empEdu', '$empRole', $empSal);
EOF
    echo
    echo "ADDING..."
    sleep 2
    echo "Employee details added successfully."
}

function view_employee() {
    echo -e "1. View all employees\n2. Enter the ID of the employee to view details"
    read -p "Enter your choice: " view_choice
    case "$view_choice" in
        1)
            echo
            sleep 0.5
            echo "VIEWING ALL EMPLOYEES..."
            sleep 1
            echo
            if [ -f "$database_file" ]; then
                sqlite3 -column -header "$database_file" <<EOF
                SELECT ID, Name, Gender, Location, Phone, Email, Education, Designation, Salary FROM employees;
EOF
            else
                echo "No employee details found."
            fi
            ;;
        2)
            echo
            read -p "Enter the ID of the employee to view details: " empID
            if [ -f "$database_file" ]; then
                employee_data=$(sqlite3 "$database_file" "SELECT * FROM employees WHERE ID = $empID;")
                if [ -n "$employee_data" ]; then
                    IFS="|" read -ra employee_fields <<< "$employee_data"
                    empName=${employee_fields[1]}
                    empGen=${employee_fields[2]}
                    empLoc=${employee_fields[3]}
                    empPhn=${employee_fields[4]}
                    empMail=${employee_fields[5]}
                    empEdu=${employee_fields[6]}
                    empRole=${employee_fields[7]}
                    empSal=${employee_fields[8]}

                    echo
                    echo "FETCHING..."
                    sleep 3
                    echo 
                    echo "-----------------------------------------------------------------------------"
                    echo "Employee details:"
                    echo
                    echo "Employee name is: $empName"
                    echo "Employee gender is: $empGen"
                    echo "Employee location is: $empLoc"
                    echo "Employee phone number is: $empPhn"
                    echo "Employee email address is: $empMail"
                    echo "Employee education qualification is: $empEdu"
                    echo "Employee designation is: $empRole"
                    echo "Employee salary is: $empSal"
                    echo "-----------------------------------------------------------------------------"
                else
                    echo
                    sleep 1
                    echo "Employee with ID $empID not found."
                fi
            else
                echo
                sleep 1
                echo "Employee details not found."
            fi
            ;;
        *)
            echo
            sleep 1
            echo "Invalid choice. Please enter 1 or 2."
            ;;
    esac
}

function update_employee() {
    read -p "Enter the ID of the employee to update: " empID
    if [ -f "$database_file" ]; then
        existing_data=$(sqlite3 "$database_file" "SELECT * FROM employees WHERE id = $empID;")
        if [ -n "$existing_data" ]; then
            IFS="|" read -ra existing_fields <<< "$existing_data"
            empName=${existing_fields[1]}
            empGen=${existing_fields[2]}
            empLoc=${existing_fields[3]}
            empPhn=${existing_fields[4]}
            empMail=${existing_fields[5]}
            empEdu=${existing_fields[6]}
            empRole=${existing_fields[7]}
            empSal=${existing_fields[8]}

            echo "Employee details: $existing_data"
            sleep 0.5
            echo

            while true; do
                read -p "Enter the new name of the employee (Press Enter to leave unchanged): " new_empName
                if [[ -z $new_empName || "$new_empName" =~ ^[a-zA-Z0-9[:space:]]+$ ]]; then
                    break
                else
                    echo "INVALID EMPLOYEE NAME. ONLY ALPHANUMERIC CHARACTERS AND SPACES ARE ALLOWED."
                fi
            done

            while true; do
                read -p "Enter the new gender of the employee (Press Enter to leave unchanged): " new_empGen
                if [[ -z $new_empGen || "$new_empGen" =~ ^[Mm][Aa][Ll][Ee]$ || "$new_empGen" =~ ^[Ff][Ee][Mm][Aa][Ll][Ee]$ ]]; then
                    break
                else
                    echo "INVALID GENDER. PLEASE ENTER 'MALE' or 'FEMALE'."
                fi
            done

            while true; do
                read -p "Enter the new location of the employee (Press Enter to leave unchanged): " new_empLoc
                if [[ -z $new_empLoc || -n $new_empLoc ]]; then
                    break
                else
                    echo "EMPLOYEE LOCATION CANNOT BE EMPTY."
                fi
            done

            while true; do
                read -p "Enter the new phone number of the employee (Press Enter to leave unchanged): " new_empPhn
                if [[ -z $new_empPhn || "$new_empPhn" =~ ^[0-9]{10}$ ]]; then
                    break
                else
                    echo "INVALID PHONE NUMBER. PLEASE ENTER A 10-digit NUMERIC VALUE."
                fi
            done

            while true; do
                read -p "Enter the new email address of the employee (Press Enter to leave unchanged): " new_empMail
                if [[ -z $new_empMail || "$new_empMail" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$ ]]; then
                    break
                else
                    echo "INVALID Email ADDRESS FORMAT. PLEASE ENTER A VALID Email ADDRESS."
                fi
            done

            while true; do
                read -p "Enter the new education qualification of the employee (Press Enter to leave unchanged): " new_empEdu
                if [[ -z $new_empEdu || -n $new_empEdu ]]; then
                    break
                else
                    echo "EDUCATION QUALIFICATION CANNOT BE EMPTY."
                fi
            done

            while true; do
                read -p "Enter the new designation of the employee (Press Enter to leave unchanged): " new_empRole
                if [[ -z $new_empRole || -n $new_empRole ]]; then
                    break
                else
                    echo "EMPLOYEE DESIGNATION CANNOT BE EMPTY."
                fi
            done

            while true; do
                read -p "Enter the new salary of the employee (Press Enter to leave unchanged): " new_empSal
                if [[ -z $new_empSal || "$new_empSal" =~ ^[1-9][0-9]*$ ]]; then
                    break
                else
                    echo "INVALID SALARY. PLEASE ENTER A POSTIVE NUMERIC VALUE."
                fi
            done

            new_empName=${new_empName:-$empName}
            new_empGen=${new_empGen:-$empGen}
            new_empLoc=${new_empLoc:-$empLoc}
            new_empPhn=${new_empPhn:-$empPhn}
            new_empMail=${new_empMail:-$empMail}
            new_empEdu=${new_empEdu:-$empEdu}
            new_empRole=${new_empRole:-$empRole}
            new_empSal=${new_empSal:-$empSal}

            sqlite3 "$database_file" <<EOF
            UPDATE employees
            SET Name = '$new_empName', Gender = '$new_empGen', Location = '$new_empLoc',
                Phone = '$new_empPhn', Email = '$new_empMail', Education = '$new_empEdu',
                Designation = '$new_empRole', Salary = $new_empSal
            WHERE ID = $empID;
EOF

            echo
            sleep 2
            echo "UPDATING..."
            echo
            sleep 2
            echo "Employee with ID $empID updated successfully."
            echo
            sleep 0.5
            echo "Updated Employee Details:"
            echo "Employee name is: $new_empName"
            echo "Employee gender is: $new_empGen"
            echo "Employee location is: $new_empLoc"
            echo "Employee phone number is: $new_empPhn"
            echo "Employee email address is: $new_empMail"
            echo "Employee education qualification is: $new_empEdu"
            echo "Employee designation is: $new_empRole"
            echo "Employee salary is: $new_empSal"
        else
            echo
            sleep 1
            echo "Employee with ID $empID not found."
        fi
    else
        echo
        sleep 1
        echo "No employee details found."
    fi
}

function delete_employee() {
    read -p "Enter the ID of the employee to delete: " empID

    sqlite3 "$database_file" <<EOF
    SELECT * FROM employees WHERE ID = $empID;
EOF

    if [ $? -eq 0 ]; then
        echo
        echo "DELETING..."
        echo
        sleep 2

        sqlite3 "$database_file" <<EOF
        DELETE FROM employees WHERE ID = $empID;
EOF

        echo "Employee with ID $empID deleted successfully."
    else
        echo "Employee with ID $empID not found."
    fi
}

function logout() {
    echo "LOGGING OUT..."
    echo
    sleep 2
    logged_in=false
    echo "Logged Out Successfully."
    echo
}

create_tables

while true; do
    if [ "$logged_in" = false ]; then
        echo
        sleep 1.5
        echo -e "EMPLOYEE MANAGEMENT SYSTEM\n1. Login\n2. Exit"
        read -p "Enter your choice: " login_choice
        case "$login_choice" in
        1)
            echo "Login to Continue"
            read -p "Enter Username: " username
            read -sp "Enter Password: " pwd
            echo
            if [ "$username" = "admin" ] && [ "$pwd" = "ramki" ]; then
		                echo "----------------------------"
                echo "LOGGING IN..."
                echo
                sleep 2
                echo "WELCOME TO EMPLOYEE MANAGEMENT SYSTEM"
                logged_in=true
            else
                echo "Please enter correct Username/Password"
            fi
            ;;
        2)
            sleep 2
            echo
            echo "Exiting Employee Management System..."
            sleep 2
            echo "Exited."
            exit
            ;;
        *)
            echo "Invalid choice. Please enter 1 to login or 2 to exit."
            ;;
        esac
    fi
    if [ "$logged_in" = true ]; then
        echo "----------------------------"
        echo -e "1. Add Employee details\n2. View Employee details\n3. Update Employee details\n4. Delete Employee details\n5. LogOut\n6. Exit"
        echo "----------------------------"
        read -p "Enter your choice: " num
        case "$num" in
        1)
            sleep 1
            echo "Add Employee details"
            add_employee
            ;;
        2)
            sleep 1
            echo "View Employee details"
            view_employee
            ;;
        3)
            sleep 1
            echo "Update Employee details"
            update_employee
            ;;
        4)
            sleep 1
            echo "Delete Employee details"
            delete_employee
            ;;
        5)  
            sleep 1
            logout
            ;;
        6)
            sleep 2
            echo
            echo "Exited."
            exit
            ;;
        *)
            echo "Invalid choice. Please enter a valid option (1-4)."
            ;;
        esac
    fi
done
