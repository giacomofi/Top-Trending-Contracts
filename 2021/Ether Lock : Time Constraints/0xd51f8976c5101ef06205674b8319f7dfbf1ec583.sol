['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-17\n', '*/\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '// Simple public version of the TokenWell concept\n', '// (public means anyone can pump)\n', '// SPDX-License-Identifier: Apache-2.0\n', '// heckles to @deanpierce\n', '//\n', '// This instance intended as a public GST faucet\n', '\n', 'contract TokenWell {\n', '    \n', '    address public token = 0x382f5DfE9eE6e309D1B9D622735e789aFde6BADe; // GST\n', '    //address public token = 0xaD6D458402F60fD3Bd25163575031ACDce07538D; // ropDAI (testing)\n', '    ERC20 erc20 = ERC20(token);\n', '\n', '    //address public owner = 0x7ab874Eeef0169ADA0d225E9801A3FfFfa26aAC3; // me\n', '    //mapping (address => bool) public pumpers;\n', '\n', '    uint public lastPumpTime = 0;\n', '    uint public interval = 60*10; // 10 minutes\n', '\n', '    uint public flowRate = 1;\n', '    uint public flowGuage = 1000;\n', '\n', '    function getBalance() public view returns(uint balance) {\n', '        balance = erc20.balanceOf(address(this));\n', '    }\n', '    \n', '    function pump() public returns(uint balance) {\n', '    //    require(pumpers[msg.sender],"NOT YOU"); // only pumpers may get free tokens\n', '        require((now-lastPumpTime)>interval, "TOO SOON"); // enforce time interval between pumps\n', '        lastPumpTime = now;\n', '        \n', '        balance = erc20.balanceOf(address(this));\n', '        erc20.transfer(msg.sender,balance/flowGuage*flowRate); // send 0.1% of the current balance\n', '    }\n', '    \n', '    /*\n', '    function transferOwnership(address newOwner) public {\n', '        require(msg.sender==owner,"NOT YOU");\n', '        owner = newOwner;\n', '    }\n', '    \n', '    function addPumper(address newAddr) public {\n', '        require(msg.sender==owner,"NOT YOU");\n', '        pumpers[newAddr]=true;\n', '    }\n', '    \n', '    function delPumper(address badAddr) public {\n', '        require(msg.sender==owner,"NOT YOU");\n', '        pumpers[badAddr]=false;\n', '    }\n', '    */\n', '}\n', '\n', '\n', 'interface ERC20{\n', '    //function approve(address spender, uint256 value)external returns(bool);\n', '    //function allowance(address _owner, address _spender) external view returns (uint256 remaining);\n', '    function balanceOf(address _owner) external view returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) external returns (bool success);\n', '}']