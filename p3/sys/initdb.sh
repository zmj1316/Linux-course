#!/bin/bash
. ./orm.sh
echo "<ID>0<>" > USER.db
echo "<ID>0<>" > COURSE.db
echo "<ID>0<>" > WORK.db
echo "<ID>0<>" > RELATION.db
echo "<ID>0<>" > U-C.db
echo "<ID>0<>" > S-W.db

U_SU="0_0_000_root_root"
U_TE="0_1_111_teather_111"
U_ST="0_2_100_stu_111"

USER_new $U_SU
USER_new $U_TE
USER_new $U_ST

C_1="0_2_Linux"
C_2="0_2_OOP"

COURSE_new $C_1
COURSE_new $C_2


# W_1="0_1_shell"

# WORK_new $W_1

