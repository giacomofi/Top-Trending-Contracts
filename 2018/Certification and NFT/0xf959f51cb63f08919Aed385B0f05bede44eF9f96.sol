['/*\n', '    \n', '    Implements the Initial Distribution of MilitaryToken™, the\n', '    true cryptocurrency token for www.MilitaryToken.io "Blockchain \n', '    for a better world". Copyright 2017, 2018 by MilitaryToken, LLC.\n', '    \n', '    All of the following might at times be used to refer to this coin: "MILS", \n', '    "MILs", "MIL$", "$MILS", "$MILs", "$MIL$", "MilitaryToken". In social \n', '    settings we prefer the text "MILs" but in formal listings "MILS" and "$MILS" \n', '    are the best symbols. In the Solidity code, the official symbol can be found \n', '    below which is "MILS". \n', '  \n', '    Portions of this code fall under the following license where noted as from\n', '    "OpenZepplin":\n', '\n', '    The MIT License (MIT)\n', '\n', '    Copyright (c) 2016 Smart Contract Solutions, Inc.\n', '\n', '    Permission is hereby granted, free of charge, to any person obtaining\n', '    a copy of this software and associated documentation files (the\n', '    "Software"), to deal in the Software without restriction, including\n', '    without limitation the rights to use, copy, modify, merge, publish,\n', '    distribute, sublicense, and/or sell copies of the Software, and to\n', '    permit persons to whom the Software is furnished to do so, subject to\n', '    the following conditions:\n', '\n', '    The above copyright notice and this permission notice shall be included\n', '    in all copies or substantial portions of the Software.\n', '\n', '    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS\n', '    OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF\n', '    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.\n', '    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY\n', '    CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,\n', '    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE\n', '    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.\n', '\n', '*/\n', '\n', 'pragma solidity 0.4.24;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' * @dev From https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '        return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Token {\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '}\n', '\n', '    \n', '/**\n', '    @title InitialDistribution\n', '    @author Stanford K. Easley\n', '\n', '*/\n', 'contract InitialDistribution {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    Token public militaryToken;\n', '    address public owner;\n', '    uint public lockUpEnd;\n', '    uint public awardsEnd;\n', '    mapping (address => uint256) public award;\n', '    mapping (address => uint256) public withdrawn;\n', '    uint256 public totalAwards = 0;\n', '    uint256 public currentAwards = 0;\n', '\n', '    /**\n', '        @param _militaryToken The address of the MilitaryToken contract.\n', '    */\n', '    constructor(address _militaryToken) public {\n', '        militaryToken = Token(_militaryToken);\n', '        owner = msg.sender;\n', '        lockUpEnd = now + (365 days);\n', '        awardsEnd = now + (730 days);\n', '    }\n', '\n', '    /**\n', '        @dev Restricts privileged functions to the contract owner.\n', '    */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '        @dev Functions that can only be called before the end of the lock-up period.\n', '    */\n', '    modifier preEnd() {\n', '        require(now < lockUpEnd);\n', '        _;\n', '    }\n', '\n', '    /**\n', '        @dev Functions that can only be called after the end of the lock-up period.\n', '    */\n', '    modifier postEnd() {\n', '        require(lockUpEnd <= now);\n', '        _;\n', '    }\n', '\n', '    /**\n', '        @dev Functions that can only be called if the awards are fully funded.\n', '     */\n', '    modifier funded() {\n', '        require(currentAwards <= militaryToken.balanceOf(address(this)));\n', '        _;\n', '    }\n', '\n', '    modifier awardsAllowed() {\n', '        require(now < awardsEnd);\n', '        _;\n', '    }\n', '\n', '    /**\n', '        @notice Changes contract ownership.\n', '        @param  newOwner The address of the new owner.\n', '    */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        if(newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '\n', '    /**\n', '        @notice Award MILs to people that will become available after lock-up period (if funded).\n', '        @param _to The address that the MILs are being awarded to.  After lock-up period awardee will be able to acquire awarded tokens.\n', '        @param _MILs The number of MILS being awarded.\n', '    */\n', '    function awardMILsTo(address _to, uint256 _MILs) public onlyOwner awardsAllowed {\n', '        \n', '        award[_to] = award[_to].add(_MILs);\n', '        totalAwards = totalAwards.add(_MILs);\n', '        currentAwards = currentAwards.add(_MILs);\n', '    }\n', '\n', '    /**\n', "        @notice Transfers awarded MILs to the caller's account.\n", '    */\n', '    function withdrawMILs(uint256 _MILs) public postEnd funded {\n', '        uint256 daysSinceEnd = (now - lockUpEnd) / 1 days;\n', '        uint256 maxPct = min(((daysSinceEnd / 30 + 1) * 10), 100);\n', '        uint256 allowed = award[msg.sender];\n', '        allowed = allowed * maxPct / 100;\n', '        allowed -= withdrawn[msg.sender];\n', '        require(_MILs <= allowed);\n', '        militaryToken.transfer(msg.sender, _MILs);\n', '        withdrawn[msg.sender] += _MILs;\n', '        currentAwards -= _MILs;\n', '    }\n', '\n', '    /**\n', '        @notice Transfers any un-awarded MILs to the contract owner.\n', '    */\n', '    function recoverUnawardedMILs() public  {\n', '        uint256 MILs = militaryToken.balanceOf(address(this));\n', '        if(totalAwards < MILs) {\n', '            militaryToken.transfer(owner, MILs - totalAwards);\n', '        }\n', '    }\n', '\n', '    function min(uint a, uint b) private pure returns (uint) {\n', '        return a < b ? a : b;\n', '    }\n', '}']