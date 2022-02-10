['pragma solidity ^0.4.18;\n', '\n', 'interface ERC20 {\n', '    function totalSupply() external view returns (uint supply);\n', '    function balanceOf(address _owner) external view returns (uint balance);\n', '    function transfer(address _to, uint _value) external; // Some ERC20 doesn&#39;t have return\n', '    function transferFrom(address _from, address _to, uint _value) external; // Some ERC20 doesn&#39;t have return\n', '    function approve(address _spender, uint _value) external; // Some ERC20 doesn&#39;t have return\n', '    function allowance(address _owner, address _spender) external view returns (uint remaining);\n', '    function decimals() external view returns(uint digits);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', '\n', 'interface BancorContract {\n', '    /**\n', '        @dev converts the token to any other token in the bancor network by following a predefined conversion path\n', '        note that when converting from an ERC20 token (as opposed to a smart token), allowance must be set beforehand\n', '\n', '        @param _path        conversion path, see conversion path format in the BancorQuickConverter contract\n', '        @param _amount      amount to convert from (in the initial source token)\n', '        @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero\n', '\n', '        @return tokens issued in return\n', '    */\n', '    function quickConvert(address[] _path, uint256 _amount, uint256 _minReturn)\n', '        external\n', '        payable\n', '        returns (uint256);\n', '}\n', '\n', '\n', 'contract TestBancorTradeBNBETH {\n', '    event Trade(uint256 srcAmount, uint256 destAmount);\n', '    \n', '    BancorContract public bancorTradingContract = BancorContract(0x8FFF721412503C85CFfef6982F2b39339481Bca9);\n', '    \n', '    function trade(address[] _path, uint256 _amount, uint256 _minReturn) {\n', '        ERC20 src = ERC20(0xB8c77482e45F1F44dE1745F52C74426C631bDD52);\n', '        src.approve(bancorTradingContract, _amount);\n', '        \n', '        uint256 destAmount = bancorTradingContract.quickConvert(_path, _amount, _minReturn);\n', '        \n', '        Trade(_amount, destAmount);\n', '    }\n', '    \n', '    function getBack() {\n', '        msg.sender.transfer(this.balance);\n', '    }\n', '    \n', '    function getBack2() {\n', '        ERC20 src = ERC20(0xB8c77482e45F1F44dE1745F52C74426C631bDD52);\n', '        src.transfer(msg.sender, src.balanceOf(this));\n', '    }\n', '    \n', '    // Receive ETH in case of trade Token -> ETH, will get ETH back from trading proxy\n', '    function () public payable {\n', '\n', '    }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', 'interface ERC20 {\n', '    function totalSupply() external view returns (uint supply);\n', '    function balanceOf(address _owner) external view returns (uint balance);\n', "    function transfer(address _to, uint _value) external; // Some ERC20 doesn't have return\n", "    function transferFrom(address _from, address _to, uint _value) external; // Some ERC20 doesn't have return\n", "    function approve(address _spender, uint _value) external; // Some ERC20 doesn't have return\n", '    function allowance(address _owner, address _spender) external view returns (uint remaining);\n', '    function decimals() external view returns(uint digits);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', '\n', 'interface BancorContract {\n', '    /**\n', '        @dev converts the token to any other token in the bancor network by following a predefined conversion path\n', '        note that when converting from an ERC20 token (as opposed to a smart token), allowance must be set beforehand\n', '\n', '        @param _path        conversion path, see conversion path format in the BancorQuickConverter contract\n', '        @param _amount      amount to convert from (in the initial source token)\n', '        @param _minReturn   if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero\n', '\n', '        @return tokens issued in return\n', '    */\n', '    function quickConvert(address[] _path, uint256 _amount, uint256 _minReturn)\n', '        external\n', '        payable\n', '        returns (uint256);\n', '}\n', '\n', '\n', 'contract TestBancorTradeBNBETH {\n', '    event Trade(uint256 srcAmount, uint256 destAmount);\n', '    \n', '    BancorContract public bancorTradingContract = BancorContract(0x8FFF721412503C85CFfef6982F2b39339481Bca9);\n', '    \n', '    function trade(address[] _path, uint256 _amount, uint256 _minReturn) {\n', '        ERC20 src = ERC20(0xB8c77482e45F1F44dE1745F52C74426C631bDD52);\n', '        src.approve(bancorTradingContract, _amount);\n', '        \n', '        uint256 destAmount = bancorTradingContract.quickConvert(_path, _amount, _minReturn);\n', '        \n', '        Trade(_amount, destAmount);\n', '    }\n', '    \n', '    function getBack() {\n', '        msg.sender.transfer(this.balance);\n', '    }\n', '    \n', '    function getBack2() {\n', '        ERC20 src = ERC20(0xB8c77482e45F1F44dE1745F52C74426C631bDD52);\n', '        src.transfer(msg.sender, src.balanceOf(this));\n', '    }\n', '    \n', '    // Receive ETH in case of trade Token -> ETH, will get ETH back from trading proxy\n', '    function () public payable {\n', '\n', '    }\n', '}']
