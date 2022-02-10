['pragma solidity ^0.4.24;\n', '\n', '/*\n', '* ---How to use:\n', '*  1. Send from ETH wallet to the smart contract address\n', '*     any amount ETH.\n', '*  2. Claim your profit by sending 0 ether transaction (1 time per hour)\n', '*  3. If you earn more than 200%, you can withdraw only one finish time\n', '*/\n', 'contract TwoHundredPercent {\n', '\n', '    using SafeMath for uint;\n', '    mapping(address => uint) public balance;\n', '    mapping(address => uint) public time;\n', '    mapping(address => uint) public percentWithdraw;\n', '    mapping(address => uint) public allPercentWithdraw;\n', '    uint public stepTime = 1 hours;\n', '    uint public countOfInvestors = 0;\n', '    address public ownerAddress = 0x45ca9f0D91b5DF4b0161f68073f7654BCdE1A0FD;\n', '    uint projectPercent = 10;\n', '\n', '    event Invest(address investor, uint256 amount);\n', '    event Withdraw(address investor, uint256 amount);\n', '\n', '    modifier userExist() {\n', '        require(balance[msg.sender] > 0, "Address not found");\n', '        _;\n', '    }\n', '\n', '    modifier checkTime() {\n', '        require(now >= time[msg.sender].add(stepTime), "Too fast payout request");\n', '        _;\n', '    }\n', '\n', '    function collectPercent() userExist checkTime internal {\n', '        if ((balance[msg.sender].mul(2)) <= allPercentWithdraw[msg.sender]) {\n', '            balance[msg.sender] = 0;\n', '            time[msg.sender] = 0;\n', '            percentWithdraw[msg.sender] = 0;\n', '        } else {\n', '            uint payout = payoutAmount();\n', '            percentWithdraw[msg.sender] = percentWithdraw[msg.sender].add(payout);\n', '            allPercentWithdraw[msg.sender] = allPercentWithdraw[msg.sender].add(payout);\n', '            msg.sender.transfer(payout);\n', '            emit Withdraw(msg.sender, payout);\n', '        }\n', '    }\n', '\n', '    function percentRate() public view returns(uint) {\n', '        uint contractBalance = address(this).balance;\n', '\n', '        if (contractBalance < 1000 ether) {\n', '            return (60);\n', '        }\n', '        if (contractBalance >= 1000 ether && contractBalance < 2500 ether) {\n', '            return (72);\n', '        }\n', '        if (contractBalance >= 2500 ether && contractBalance < 5000 ether) {\n', '            return (84);\n', '        }\n', '        if (contractBalance >= 5000 ether) {\n', '            return (90);\n', '        }\n', '    }\n', '\n', '    function payoutAmount() public view returns(uint256) {\n', '        uint256 percent = percentRate();\n', '        uint256 different = now.sub(time[msg.sender]).div(stepTime);\n', '        uint256 rate = balance[msg.sender].mul(percent).div(1000);\n', '        uint256 withdrawalAmount = rate.mul(different).div(24).sub(percentWithdraw[msg.sender]);\n', '\n', '        return withdrawalAmount;\n', '    }\n', '\n', '    function deposit() private {\n', '        if (msg.value > 0) {\n', '            if (balance[msg.sender] == 0) {\n', '                countOfInvestors += 1;\n', '            }\n', '            if (balance[msg.sender] > 0 && now > time[msg.sender].add(stepTime)) {\n', '                collectPercent();\n', '                percentWithdraw[msg.sender] = 0;\n', '            }\n', '            balance[msg.sender] = balance[msg.sender].add(msg.value);\n', '            time[msg.sender] = now;\n', '\n', '            ownerAddress.transfer(msg.value.mul(projectPercent).div(100));\n', '            emit Invest(msg.sender, msg.value);\n', '        } else {\n', '            collectPercent();\n', '        }\n', '    }\n', '\n', '    function() external payable {\n', '        deposit();\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}']