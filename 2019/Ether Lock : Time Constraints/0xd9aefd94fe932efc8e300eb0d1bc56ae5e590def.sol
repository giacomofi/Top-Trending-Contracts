['// solium-disable linebreak-style\n', 'pragma solidity ^0.5.0;\n', '\n', 'contract CryptoTycoonsVIPLib{\n', '    \n', '    address payable public owner;\n', '    \n', '    // Accumulated jackpot fund.\n', '    uint128 public jackpotSize;\n', '    uint128 public rankingRewardSize;\n', '    \n', '    mapping (address => uint) userExpPool;\n', '    mapping (address => bool) public callerMap;\n', '\n', '    event RankingRewardPayment(address indexed beneficiary, uint amount);\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner, "OnlyOwner methods called by non-owner.");\n', '        _;\n', '    }\n', '\n', '    modifier onlyCaller {\n', '        bool isCaller = callerMap[msg.sender];\n', '        require(isCaller, "onlyCaller methods called by non-caller.");\n', '        _;\n', '    }\n', '\n', '    constructor() public{\n', '        owner = msg.sender;\n', '        callerMap[owner] = true;\n', '    }\n', '\n', "    // Fallback function deliberately left empty. It's primary use case\n", '    // is to top up the bank roll.\n', '    function () external payable {\n', '    }\n', '\n', '    function kill() external onlyOwner {\n', '        selfdestruct(owner);\n', '    }\n', '\n', '    function addCaller(address caller) public onlyOwner{\n', '        bool isCaller = callerMap[caller];\n', '        if (isCaller == false){\n', '            callerMap[caller] = true;\n', '        }\n', '    }\n', '\n', '    function deleteCaller(address caller) external onlyOwner {\n', '        bool isCaller = callerMap[caller];\n', '        if (isCaller == true) {\n', '            callerMap[caller] = false;\n', '        }\n', '    }\n', '\n', '    function addUserExp(address addr, uint256 amount) public onlyCaller{\n', '        uint exp = userExpPool[addr];\n', '        exp = exp + amount;\n', '        userExpPool[addr] = exp;\n', '    }\n', '\n', '    function getUserExp(address addr) public view returns(uint256 exp){\n', '        return userExpPool[addr];\n', '    }\n', '\n', '    function getVIPLevel(address user) public view returns (uint256 level) {\n', '        uint exp = userExpPool[user];\n', '\n', '        if(exp >= 30 ether && exp < 150 ether){\n', '            level = 1;\n', '        } else if(exp >= 150 ether && exp < 300 ether){\n', '            level = 2;\n', '        } else if(exp >= 300 ether && exp < 1500 ether){\n', '            level = 3;\n', '        } else if(exp >= 1500 ether && exp < 3000 ether){\n', '            level = 4;\n', '        } else if(exp >= 3000 ether && exp < 15000 ether){\n', '            level = 5;\n', '        } else if(exp >= 15000 ether && exp < 30000 ether){\n', '            level = 6;\n', '        } else if(exp >= 30000 ether && exp < 150000 ether){\n', '            level = 7;\n', '        } else if(exp >= 150000 ether){\n', '            level = 8;\n', '        } else{\n', '            level = 0;\n', '        }\n', '\n', '        return level;\n', '    }\n', '\n', '    function getVIPBounusRate(address user) public view returns (uint256 rate){\n', '        uint level = getVIPLevel(user);\n', '\n', '        if(level == 1){\n', '            rate = 1;\n', '        } else if(level == 2){\n', '            rate = 2;\n', '        } else if(level == 3){\n', '            rate = 3;\n', '        } else if(level == 4){\n', '            rate = 4;\n', '        } else if(level == 5){\n', '            rate = 5;\n', '        } else if(level == 6){\n', '            rate = 7;\n', '        } else if(level == 7){\n', '            rate = 9;\n', '        } else if(level == 8){\n', '            rate = 11;\n', '        } else if(level == 9){\n', '            rate = 13;\n', '        } else if(level == 10){\n', '            rate = 15;\n', '        } else{\n', '            rate = 0;\n', '        }\n', '    }\n', '\n', '    // This function is used to bump up the jackpot fund. Cannot be used to lower it.\n', '    function increaseJackpot(uint increaseAmount) external onlyCaller {\n', '        require (increaseAmount <= address(this).balance, "Increase amount larger than balance.");\n', '        require (jackpotSize + increaseAmount <= address(this).balance, "Not enough funds.");\n', '        jackpotSize += uint128(increaseAmount);\n', '    }\n', '\n', '    function payJackpotReward(address payable to) external onlyCaller{\n', '        to.transfer(jackpotSize);\n', '        jackpotSize = 0;\n', '    }\n', '\n', '    function getJackpotSize() external view returns (uint256){\n', '        return jackpotSize;\n', '    }\n', '\n', '    function increaseRankingReward(uint amount) public onlyCaller{\n', '        require (amount <= address(this).balance, "Increase amount larger than balance.");\n', '        require (rankingRewardSize + amount <= address(this).balance, "Not enough funds.");\n', '        rankingRewardSize += uint128(amount);\n', '    }\n', '\n', '    function payRankingReward(address payable to) external onlyCaller {\n', '        uint128 prize = rankingRewardSize / 2;\n', '        rankingRewardSize = rankingRewardSize - prize;\n', '        if(to.send(prize)){\n', '            emit RankingRewardPayment(to, prize);\n', '        }\n', '    }\n', '\n', '    function getRankingRewardSize() external view returns (uint128){\n', '        return rankingRewardSize;\n', '    }\n', '}']