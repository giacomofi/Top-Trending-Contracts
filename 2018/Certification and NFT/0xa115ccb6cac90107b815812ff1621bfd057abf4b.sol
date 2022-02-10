['/* ==================================================================== */\n', '/* Copyright (c) 2018 The ether.online Project.  All rights reserved.\n', '/* \n', '/* https://ether.online  The first RPG game of blockchain \n', '/*  \n', '/* authors <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="9ceef5fff7f4e9f2e8f9eeb2eff4f9f2dcfbf1fdf5f0b2fff3f1">[email&#160;protected]</a>   \n', '/*         <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="99eafceaecf7fdf0f7fed9fef4f8f0f5b7faf6f4">[email&#160;protected]</a>            \n', '/* ==================================================================== */\n', '\n', 'pragma solidity ^0.4.20;\n', '\n', 'contract AccessAdmin {\n', '    bool public isPaused = false;\n', '    address public addrAdmin;  \n', '\n', '    event AdminTransferred(address indexed preAdmin, address indexed newAdmin);\n', '\n', '    function AccessAdmin() public {\n', '        addrAdmin = msg.sender;\n', '    }  \n', '\n', '\n', '    modifier onlyAdmin() {\n', '        require(msg.sender == addrAdmin);\n', '        _;\n', '    }\n', '\n', '    modifier whenNotPaused() {\n', '        require(!isPaused);\n', '        _;\n', '    }\n', '\n', '    modifier whenPaused {\n', '        require(isPaused);\n', '        _;\n', '    }\n', '\n', '    function setAdmin(address _newAdmin) external onlyAdmin {\n', '        require(_newAdmin != address(0));\n', '        AdminTransferred(addrAdmin, _newAdmin);\n', '        addrAdmin = _newAdmin;\n', '    }\n', '\n', '    function doPause() external onlyAdmin whenNotPaused {\n', '        isPaused = true;\n', '    }\n', '\n', '    function doUnpause() external onlyAdmin whenPaused {\n', '        isPaused = false;\n', '    }\n', '}\n', '\n', 'contract AccessService is AccessAdmin {\n', '    address public addrService;\n', '    address public addrFinance;\n', '\n', '    modifier onlyService() {\n', '        require(msg.sender == addrService);\n', '        _;\n', '    }\n', '\n', '    modifier onlyFinance() {\n', '        require(msg.sender == addrFinance);\n', '        _;\n', '    }\n', '\n', '    function setService(address _newService) external {\n', '        require(msg.sender == addrService || msg.sender == addrAdmin);\n', '        require(_newService != address(0));\n', '        addrService = _newService;\n', '    }\n', '\n', '    function setFinance(address _newFinance) external {\n', '        require(msg.sender == addrFinance || msg.sender == addrAdmin);\n', '        require(_newFinance != address(0));\n', '        addrFinance = _newFinance;\n', '    }\n', '\n', '    function withdraw(address _target, uint256 _amount) \n', '        external \n', '    {\n', '        require(msg.sender == addrFinance || msg.sender == addrAdmin);\n', '        require(_amount > 0);\n', '        address receiver = _target == address(0) ? addrFinance : _target;\n', '        uint256 balance = this.balance;\n', '        if (_amount < balance) {\n', '            receiver.transfer(_amount);\n', '        } else {\n', '            receiver.transfer(this.balance);\n', '        }      \n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract PrizePool is AccessService {\n', '    using SafeMath for uint256;\n', '\n', '    event SendPrizeSuccesss(uint64 flag, uint256 oldBalance, uint256 sendVal);\n', '    event PrizeTimeClear(uint256 newVal);\n', '    uint64 public nextPrizeTime;\n', '    uint256 maxPrizeOneDay = 30;\n', '\n', '    \n', '    function PrizePool() public {\n', '        addrAdmin = msg.sender;\n', '        addrService = msg.sender;\n', '        addrFinance = msg.sender;\n', '    }\n', '\n', '    function() external payable {\n', '\n', '    }\n', '\n', '    function getBalance() external view returns(uint256) {\n', '        return this.balance;\n', '    }\n', '\n', '    function clearNextPrizeTime() external onlyService {\n', '        nextPrizeTime = 0;\n', '        PrizeTimeClear(0);\n', '    }\n', '\n', '    function setMaxPrizeOneDay(uint256 val) external onlyAdmin {\n', '        require(val > 0 && val < 100);\n', '        require(val != maxPrizeOneDay);\n', '        maxPrizeOneDay = val;\n', '    }\n', '\n', '    // gas 130000 per 10 address\n', '    function sendPrize(address[] winners, uint256[] amounts, uint64 _flag) \n', '        external \n', '        onlyService \n', '        whenNotPaused\n', '    {\n', '        uint64 tmNow = uint64(block.timestamp);\n', '        uint256 length = winners.length;\n', '        require(length == amounts.length);\n', '        require(length <= 64);\n', '\n', '        uint256 sum = 0;\n', '        for (uint32 i = 0; i < length; ++i) {\n', '            sum = sum.add(amounts[i]);\n', '        }\n', '        uint256 balance = this.balance;\n', '        require((sum.mul(100).div(balance)) <= maxPrizeOneDay);\n', '\n', '        address addrZero = address(0);\n', '        for (uint32 j = 0; j < length; ++j) {\n', '            if (winners[j] != addrZero) {\n', '                winners[j].transfer(amounts[j]);\n', '            }\n', '        }\n', '        nextPrizeTime = tmNow + 72000;\n', '        SendPrizeSuccesss(_flag, balance, sum);\n', '    }\n', '}']