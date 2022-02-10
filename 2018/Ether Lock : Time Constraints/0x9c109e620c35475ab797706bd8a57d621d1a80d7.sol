['pragma solidity ^0.4.16;\n', '\n', '\n', 'contract ERC20 {\n', '    function balanceOf(address tokenOwner) public constant returns (uint256 balance);\n', '    function transfer(address to, uint256 tokens) public returns (bool success);\n', '}\n', '\n', '\n', 'contract owned {\n', '    function owned() public { owner = msg.sender; }\n', '    address owner;\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '}\n', '\n', '\n', 'contract TeamTokenLock is owned {\n', '\n', '    address _tokenAddress = 0xAF815e887b039Fc06a8ddDcC7Ec4f57757616Cd2;\n', '    uint256 _startTime = 1534723200;  // Aug 20, 2018\n', '    uint256 _teamTokenAmount = 1600000000e18;  // 1.6 Billion\n', '    uint256 _totalWithdrawAmount = 0;\n', '\n', '    function getAllowedAmountByTeam() public constant returns (uint256 amount) {\n', '        if (now >= _startTime + (731 days)) {\n', '            // Aug 20, 2020\n', '            return _teamTokenAmount;\n', '        } else if (now >= _startTime + (700 days)) {\n', '            // July 20, 2020\n', '            return _teamTokenAmount / uint(24) * 23;\n', '        } else if (now >= _startTime + (670 days)) {\n', '            // June 20, 2020\n', '            return _teamTokenAmount / uint(24) * 22;\n', '        } else if (now >= _startTime + (639 days)) {\n', '            // May 20, 2020\n', '            return _teamTokenAmount / uint(24) * 21;\n', '        } else if (now >= _startTime + (609 days)) {\n', '            // April 20, 2020\n', '            return _teamTokenAmount / uint(24) * 20;\n', '        } else if (now >= _startTime + (578 days)) {\n', '            // March 20, 2020\n', '            return _teamTokenAmount / uint(24) * 19;\n', '        } else if (now >= _startTime + (549 days)) {\n', '            // Febuary 20, 2020\n', '            return _teamTokenAmount / uint(24) * 18;\n', '        } else if (now >= _startTime + (518 days)) {\n', '            // January 20, 2020\n', '            return _teamTokenAmount / uint(24) * 17;\n', '        } else if (now >= _startTime + (487 days)) {\n', '            // December 20, 2019\n', '            return _teamTokenAmount / uint(24) * 16;\n', '        } else if (now >= _startTime + (457 days)) {\n', '            // November 20, 2019\n', '            return _teamTokenAmount / uint(24) * 15;\n', '        } else if (now >= _startTime + (426 days)) {\n', '            // October 20, 2019\n', '            return _teamTokenAmount / uint(24) * 14;\n', '        } else if (now >= _startTime + (396 days)) {\n', '            // September 20, 2019\n', '            return _teamTokenAmount / uint(24) * 13;\n', '        } else if (now >= _startTime + (365 days)) {\n', '            // August 20, 2019\n', '            return _teamTokenAmount / uint(24) * 12;\n', '        } else if (now >= _startTime + (334 days)) {\n', '            // July 20, 2019\n', '            return _teamTokenAmount / uint(24) * 11;\n', '        } else if (now >= _startTime + (304 days)) {\n', '            // June 20, 2019\n', '            return _teamTokenAmount / uint(24) * 10;\n', '        } else if (now >= _startTime + (273 days)) {\n', '            // May 20, 2019\n', '            return _teamTokenAmount / uint(24) * 9;\n', '        } else if (now >= _startTime + (243 days)) {\n', '            // April 20, 2019\n', '            return _teamTokenAmount / uint(24) * 8;\n', '        } else if (now >= _startTime + (212 days)) {\n', '            // March 20, 2019\n', '            return _teamTokenAmount / uint(24) * 7;\n', '        } else if (now >= _startTime + (184 days)) {\n', '            // Febuary 20, 2019\n', '            return _teamTokenAmount / uint(24) * 6;\n', '        } else if (now >= _startTime + (153 days)) {\n', '            // January 20, 2019\n', '            return _teamTokenAmount / uint(24) * 5;\n', '        } else if (now >= _startTime + (122 days)) {\n', '            // December 20, 2018\n', '            return _teamTokenAmount / uint(24) * 4;\n', '        } else if (now >= _startTime + (92 days)) {\n', '            // Nobember 20, 2018\n', '            return _teamTokenAmount / uint(24) * 3;\n', '        } else if (now >= _startTime + (61 days)) {\n', '            // October 20, 2018\n', '            return _teamTokenAmount / uint(24) * 2;\n', '        } else if (now >= _startTime + (31 days)) {\n', '            // September 20, 2018\n', '            return _teamTokenAmount / uint(24);\n', '        } else {\n', '            return 0;\n', '        }\n', '    }\n', '\n', '    function withdrawByTeam(address toAddress, uint256 amount) public onlyOwner {\n', '        require(now >= _startTime);\n', '\n', '        uint256 allowedAmount = getAllowedAmountByTeam();\n', '\n', '        require(amount + _totalWithdrawAmount <= allowedAmount);\n', '\n', '        _totalWithdrawAmount += amount;\n', '\n', '        ERC20(_tokenAddress).transfer(toAddress, amount);\n', '    }\n', '\n', '    function withdrawByFoundation(address toAddress, uint256 amount) public onlyOwner {\n', '        require(now >= _startTime + (731 days));\n', '\n', '        ERC20(_tokenAddress).transfer(toAddress, amount);\n', '    }\n', '}']