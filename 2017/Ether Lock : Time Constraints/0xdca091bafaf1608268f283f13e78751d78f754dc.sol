['contract BirthdayGift {\n', '    \n', '    address public owner = 0x770F34Fdd214b36f2494ed57bb827B4c319E5BaA;\n', '    address public recipient = 0x6A93e96E999326eB02f759EaF5d4e71d0a8653e8;\n', '    \n', '    // 5 Apr 2023 00:00:00 PST | 5 Apr 2023 08:00:00 GMT\n', '    uint256 public unlockTime = 1680681600; \n', '    \n', '    function BirthdayGift () public {\n', '    }\n', '    \n', '    function DaysTillUnlock () public constant returns (uint256 _days) {\n', '        if (now > unlockTime) {\n', '            return 0;\n', '        }\n', '        return (unlockTime - now) / 60 / 60 / 24;\n', '    }\n', '    \n', '    function SetOwner (address _newOwner) public {\n', '        require (msg.sender == owner);\n', '        owner = _newOwner; \n', '    }  \n', '    \n', '    function SetUnlockTime (uint256 _time) public {\n', '        require (msg.sender == owner);\n', '        unlockTime = _time;\n', '    }\n', '    \n', '    function SetRecipient (address _recipient) public {\n', '        require (msg.sender == owner);\n', '        recipient = _recipient;\n', '    }\n', '    \n', '    function OpenGift () public {\n', '        require (msg.sender == recipient);\n', '        require (now >= unlockTime);\n', '        selfdestruct (recipient);\n', '    }\n', '}']