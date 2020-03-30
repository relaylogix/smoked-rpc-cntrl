#!/bin/bash

        # Purpose: Remote Procedure Call Interface For Smoke.io
        # Scripter: Relaylogix
        # Contact: http://smoke.io/@relaylogix

        # Clear Output Window

        printf "\f"

        # Included Global Script Librarys

. ./l0g1x.lib
. ./rnd_cmt.func
. ./witness.func

        # Local Script Functions

        # Local Declarations

        touch l0g1x.config

        read -r active_accounts_path < l0g1x.config

        # Script Entrance Point

        # Interface Title Banner

        printf "${green}Smoke.io RPC Interface Loaded...\nCreated By:${red} @relaylogix\n${green}http://smoke.io/@relaylogix\n\n${blue}For help please reachout to me on the Smoke Network Discord channel.\n\n${white}"

        # Main Structure Of Script Start

        while :
        do
                # Display User With List Of Commands To Use

                printf "${green}-----==================================================-----\n"
                printf "${green}-----=====[ SMOKE.IO  Interface Control Commands ]=====-----\n"
                printf "${green}-----==================================================-----\n\n"
                printf "${white}0      Clear Output Window\n1      Setup Config\n1a     Current Config\n2      Add Active User\n"
                printf "2a     Display Active User List\n2b     Generate Random Account From Actives List\n3      Smoke Accounts Count\n4      Registered Witness Count\n4a     List Top Active Witnesses\n"
                printf "4b     Request Current Missed Blocks For Witness\n5      Request Current Smoke Network Hard Fork Version\n6      The @d00k13-Get Comments And Random Comment Author\n"
                                printf "x      Exits Interface\n\n       ${green}Current Actives List Path:${red} ${active_accounts_path}\n"
                printf "${red}\n[Type Your Control Selection Number]----->${white}"
                read user_input
                case "$user_input" in
                        0)
                                # Clear Output Screen
                                printf "\f"
                                ;;
                        1)
                                # Current Config Setup
                                printf "${red}Specify Path To Active Accounts File?  ${white}"
                                read active_accounts_path
                                printf "\n${red}Verify Path To Set For Active Accounts Is:${green} ${active_accounts_path}\n"
                                printf "${red}Is This Path Correct? y For Ok, Any Other Key To Cancel.  "
                                read user_ack
                                case "$user_ack" in
                                        y)
                                                touch ${active_accounts_path}
                                                echo ${active_accounts_path} > l0g1x.config
                                                printf "${green}Config Updated!\n\n${white}"
                                                ;;
                                        *)
                                                printf "${red} User Aborted Config Update. Try Again.\n${white}"
                                                read -r active_accounts_path < l0g1x.config
                                                ;;
                                esac
                                ;;
                        1a)
                                # Display Current Setup
                                printf "${green}The Current Active Accounts File Is Located At: ${active_accounts_path}\n${white}"
                                ;;
                        2a)
                                ret_data=$(cat "$active_accounts_path")
                                actives_count=$(wc -l "$active_accounts_path")
                                active_accounts_len=${#active_accounts_path}
                                clean_string 0 "${active_accounts_len}" "${actives_count}"
                                sleep 0.25
                                clean_string 0 1 "$CLEANED_STRING"
                                printf "${green}There Are Currently${red} ${CLEANED_STRING} ${green}Accounts On The Active List\n"
                                printf "${red}${ret_data}${white}\n\n"
                                ;;
                        2b)
                                get_weekly_actives "${active_accounts_path}"
                                printf "\n${red}This weeks active account winner is:${yel} $WEEKLY_ACTIVE${white}\n\n"
                                ;;
                        3)
                                printf "\n\n${green}The current account count on the Smoke Network is...\n"


                                ret_data=``` curl -s --data '{"jsonrpc": "2.0", "method": "get_account_count", "params": [[ ]], "id": 0 }' https://rpc.smoke.io ```
                                clean_string 17 1 $ret_data
                                printf "There are currently  ---  ${red}${CLEANED_STRING}${green}  ---  accounts registered on the ${white}SMOKE ${green}blockchain..\n\n${white}"
                                ;;
                        4)
                                printf "\n\n${green}The current number of registered Smoke Network witnesses is...\n${white}"
                                ret_data=``` curl -s --data '{"jsonrpc": "2.0", "method": "get_witness_count", "params": [[ ]], "id": 1 }' https://rpc.smoke.io ```
                                clean_string 17 1 $ret_data
                                printf "${green}There are currently  ---  ${red}${CLEANED_STRING}${green}  ---  witness accounts registered on the ${white}SMOKE ${green}blockchain..\n\n${white}"
                                ;;
                        4a)
                                printf "\n\n${green}The current active Smoke Network witnesses are...\n${white}"
                                ret_data=``` curl -s --data '{"jsonrpc": "2.0", "method": "get_active_witnesses", "params": [[ ]], "id": 2 }' https://rpc.smoke.io ```
                                clean_string 18 2 $ret_data
                                printf "${green}The current top witnesses are  ---  ${red}${CLEANED_STRING}\n\n${white}"
                                for name in ${CLEANED_STRING}
                                do
                                        echo $name"\n"
                                done
                                ;;
                        4b)
                                witness_missed_blocks
                                ;;
                        5)
                                ret_data=``` curl -s --data '{"jsonrpc": "2.0", "method": "get_hardfork_version", "params": [[ ]], "id": 3 }' https://rpc.smoke.io ```
                                clean_string 18 2 $ret_data
                                printf "${green}The Current Smoke Network Hard Fork Version Is  ---  ${green}${CLEANED_STRING}\n\n${white}"
                                ;;
                        6)
                                # Get Post Comments
                                get_comment_author
                                ;;
                        x)
                                # Close Interface
                                exit 0
                                ;;
                        *)
                                # Un Reckognized Command
                                printf "${red}That command is not reckognized.${white}\n"
                                ;;
                esac
        done
