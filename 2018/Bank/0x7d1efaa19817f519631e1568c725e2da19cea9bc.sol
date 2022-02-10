['pragma solidity 0.4.19;\n', '\n', 'contract ERC20Interface {\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '}\n', '\n', 'contract FaceterTokenLockV2 {\n', '    address constant RECEIVER = 0x102aEe443704BBd96f31BcFCA9DA8E86f0128803;\n', '    uint constant AMOUNT = 18750000 * 10**18;\n', '    ERC20Interface constant FaceterToken = ERC20Interface(0x4695c7AC68eb86c1079c7d7D53Af2F42DB8a6799);\n', '    uint8 public unlockStep;\n', '\n', '    function unlock() public returns(bool) {\n', '        uint unlockAmount = 0;\n', '        // 1 July 2018\n', '        if (unlockStep == 0 && now >= 1530403200) {\n', '            unlockAmount = AMOUNT;\n', '        // 1 October 2018\n', '        } else if (unlockStep == 1 && now >= 1538352000) {\n', '            unlockAmount = AMOUNT;\n', '        // 1 January 2019\n', '        } else if (unlockStep == 2 && now >= 1546300800) {\n', '            unlockAmount = AMOUNT;\n', '        // 1 April 2019\n', '        } else if (unlockStep == 3 && now >= 1554076800) {\n', '            unlockAmount = AMOUNT;\n', '        // 1 July 2019\n', '        } else if (unlockStep == 4 && now >= 1561939200) {\n', '            unlockAmount = AMOUNT;\n', '        // 1 October 2019\n', '        } else if (unlockStep == 5 && now >= 1569888000) {\n', '            unlockAmount = AMOUNT;\n', '        // 1 January 2020\n', '        } else if (unlockStep == 6 && now >= 1577836800) {\n', '            unlockAmount = AMOUNT;\n', '        // 1 April 2020\n', '        } else if (unlockStep == 7 && now >= 1585699200) {\n', '            unlockAmount = FaceterToken.balanceOf(this);\n', '        }\n', '        if (unlockAmount == 0) {\n', '            return false;\n', '        }\n', '        unlockStep++;\n', '        require(FaceterToken.transfer(RECEIVER, unlockAmount));\n', '        return true;\n', '    }\n', '\n', '    function () public {\n', '        unlock();\n', '    }\n', '\n', '    function recoverTokens(ERC20Interface _token) public returns(bool) {\n', '        // Don&#39;t allow recovering Faceter Token till the end of lock.\n', '        if (_token == FaceterToken && now < 1585699200 && unlockStep != 8) {\n', '            return false;\n', '        }\n', '        return _token.transfer(RECEIVER, _token.balanceOf(this));\n', '    }\n', '}']