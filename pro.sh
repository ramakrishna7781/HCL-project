function add_employee() {
    read -p "Enter the ID of the employee: " empID
    if ! [[ $empID =~ ^[1-9][0-9]*$ ]]; then
        echo "Invalid employee ID. Please enter a positive integer."
        return
    fi
    read -p "Enter the name of the employee: " empName
    if [[ -z $empName ]]; then
        echo "Employee name cannot be empty."
        return
    fi
    read -p "Enter the gender of the employee: " empGen
    if [[ ! "$empGen" =~ ^[Mm][Aa][Ll][Ee]$ && ! "$empGen" =~ ^[Ff][Ee][Mm][Aa][Ll][Ee]$ ]]; then
    echo "Invalid gender. Please enter 'Male' or 'Female'."
    return
    fi
    read -p "Enter the location of the employee: " empLoc
    if [[ -z $empLoc ]]; then
        echo "Employee location cannot be empty."
        return
    fi
    read -p "Enter the phone number of the employee: " empPhn
    if ! [[ $empPhn =~ ^[0-9]+$ ]]; then
        echo "Invalid phone number. Please enter a numeric value."
        return
    fi
    read -p "Enter the email address of the employee: " empMail
    if ! [[ $empMail =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$ ]]; then
    echo "Invalid email address format. Please enter a valid email address."
    return
    fi
    read -p "Enter the education qualification of the employee: " empEdu
    if [[ -z $empEdu ]]; then
        echo "Education qualification cannot be empty."
        return
    fi
    read -p "Enter the designation of the employee: " empRole
    if [[ -z $empRole ]]; then
        echo "Employee designation cannot be empty."
        return
    fi
    read -p "Enter the salary of the employee: " empSal
    if ! [[ $empSal =~ ^[1-9][0-9]*$ ]]; then
        echo "Invalid salary. Please enter a positive numeric value."
        return
    fi
    echo "|$empID|---|$empName|---|$empGen|---|$empLoc|---|$empPhn|---|$empMail|---|$empEdu|---|$empRole|---|$empSal|" >> lat.txt
    echo
    echo "ADDING..."
    sleep 2
    echo "Employee details added successfully."
}
