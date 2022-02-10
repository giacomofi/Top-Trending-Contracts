['pragma solidity ^0.4.13;\n', '/*\n', '    Copyright 2017, Griff Green\n', '\n', '    This program is free software: you can redistribute it and/or modify\n', '    it under the terms of the GNU General Public License as published by\n', '    the Free Software Foundation, either version 3 of the License, or\n', '    (at your option) any later version.\n', '\n', '    This program is distributed in the hope that it will be useful,\n', '    but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '    GNU General Public License for more details.\n', '\n', '    You should have received a copy of the GNU General Public License\n', '    along with this program.  If not, see <http://www.gnu.org/licenses/>.\n', ' */\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of BasicToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/// @dev `Escapable` is a base level contract for and contract that wants to\n', '///  add an escape hatch for a contract that holds ETH or ERC20 tokens. This\n', '///  contract creates an `escapeHatch()` function to send its `baseTokens` to\n', '///  `escapeHatchDestination` when called by the `escapeHatchCaller` in the case that\n', '///  something unexpected happens\n', 'contract Escapable {\n', '    BasicToken public baseToken;\n', '\n', '    address public escapeHatchCaller;\n', '    address public escapeHatchDestination;\n', '\n', '    /// @notice The Constructor assigns the `escapeHatchDestination`, the\n', '    ///  `escapeHatchCaller`, and the `baseToken`\n', '    /// @param _baseToken The address of the token that is used as a store value\n', '    ///  for this contract, 0x0 in case of ether. The token must have the ERC20\n', '    ///  standard `balanceOf()` and `transfer()` functions\n', '    /// @param _escapeHatchDestination The address of a safe location (usu a\n', '    ///  Multisig) to send the `baseToken` held in this contract\n', '    /// @param _escapeHatchCaller The address of a trusted account or contract to\n', '    ///  call `escapeHatch()` to send the `baseToken` in this contract to the\n', '    ///  `escapeHatchDestination` it would be ideal that `escapeHatchCaller`\n', '    /// cannot move funds out of `escapeHatchDestination`\n', '    function Escapable(\n', '        address _baseToken,\n', '        address _escapeHatchCaller,\n', '        address _escapeHatchDestination) {\n', '        baseToken = BasicToken(_baseToken);\n', '        escapeHatchCaller = _escapeHatchCaller;\n', '        escapeHatchDestination = _escapeHatchDestination;\n', '    }\n', '\n', '    /// @dev The addresses preassigned the `escapeHatchCaller` role\n', '    ///  is the only addresses that can call a function with this modifier\n', '    modifier onlyEscapeHatchCaller {\n', '        require (msg.sender == escapeHatchCaller);\n', '        _;\n', '    }\n', '\n', '    /// @notice The `escapeHatch()` should only be called as a last resort if a\n', '    /// security issue is uncovered or something unexpected happened\n', '    function escapeHatch() onlyEscapeHatchCaller {\n', '        uint total = getBalance();\n', '        // Send the total balance of this contract to the `escapeHatchDestination`\n', '        transfer(escapeHatchDestination, total);\n', '        EscapeHatchCalled(total);\n', '    }\n', '    /// @notice Changes the address assigned to call `escapeHatch()`\n', '    /// @param _newEscapeHatchCaller The address of a trusted account or contract to\n', '    ///  call `escapeHatch()` to send the ether in this contract to the\n', '    ///  `escapeHatchDestination` it would be ideal that `escapeHatchCaller` cannot\n', '    ///  move funds out of `escapeHatchDestination`\n', '    function changeEscapeHatchCaller(address _newEscapeHatchCaller\n', '        ) onlyEscapeHatchCaller \n', '    {\n', '        escapeHatchCaller = _newEscapeHatchCaller;\n', '        EscapeHatchCallerChanged(escapeHatchCaller);\n', '    }\n', '    /// @notice Returns the balance of the `baseToken` stored in this contract\n', '    function getBalance() constant returns(uint) {\n', '        if (address(baseToken) != 0) {\n', '            return baseToken.balanceOf(this);\n', '        } else {\n', '            return this.balance;\n', '        }\n', '    }\n', '    /// @notice Sends an `_amount` of `baseToken` to `_to` from this contract,\n', '    /// and it can only be called by the contract itself\n', '    /// @param _to The address of the recipient\n', '    /// @param _amount The amount of `baseToken to be sent\n', '    function transfer(address _to, uint _amount) internal {\n', '        if (address(baseToken) != 0) {\n', '            require (baseToken.transfer(_to, _amount));\n', '        } else {\n', '            require ( _to.send(_amount));\n', '        }\n', '    }\n', '\n', '\n', '//////\n', '// Receive Ether\n', '//////\n', '\n', '    /// @notice Called anytime ether is sent to the contract && creates an event\n', '    /// to more easily track the incoming transactions\n', '    function receiveEther() payable {\n', '        // Do not accept ether if baseToken is not ETH\n', '        require (address(baseToken) == 0);\n', '        EtherReceived(msg.sender, msg.value);\n', '    }\n', '\n', '//////////\n', '// Safety Methods\n', '//////////\n', '\n', '    /// @notice This method can be used by the controller to extract mistakenly\n', '    ///  sent tokens to this contract.\n', '    /// @param _token The address of the token contract that you want to recover\n', '    ///  set to 0 in case you want to extract ether.\n', '    function claimTokens(address _token) public onlyEscapeHatchCaller {\n', '        if (_token == 0x0) {\n', '            escapeHatchDestination.transfer(this.balance);\n', '            return;\n', '        }\n', '\n', '        BasicToken token = BasicToken(_token);\n', '        uint256 balance = token.balanceOf(this);\n', '        token.transfer(escapeHatchDestination, balance);\n', '        ClaimedTokens(_token, escapeHatchDestination, balance);\n', '    }\n', '\n', '    /// @notice The fall back function is called whenever ether is sent to this\n', '    ///  contract\n', '    function () payable {\n', '        receiveEther();\n', '    }\n', '\n', '    event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);\n', '    event EscapeHatchCalled(uint amount);\n', '    event EscapeHatchCallerChanged(address indexed newEscapeHatchCaller);\n', '    event EtherReceived(address indexed from, uint amount);\n', '}\n', '\n', '/// @title Mexico Matcher\n', '/// @author Vojtech Simetka, Jordi Baylina, Dani Philia, Arthur Lunn, Griff Green\n', '/// @notice This contract is used to match donations inspired by the generosity\n', '///  of Bitso:  \n', '///  The escapeHatch allows removal of any other tokens deposited by accident.\n', '\n', '\n', '/// @dev The main contract which forwards funds sent to contract.\n', 'contract MexicoMatcher is Escapable {\n', '    address public beneficiary; // expected to be a Giveth campaign\n', '\n', '    /// @notice The Constructor assigns the `beneficiary`, the\n', '    ///  `escapeHatchDestination` and the `escapeHatchCaller` as well as deploys\n', '    ///  the contract to the blockchain (obviously)\n', '    /// @param _beneficiary The address that will receive donations\n', '    /// @param _escapeHatchDestination The address of a safe location (usually a\n', '    ///  Multisig) to send the ether deposited to be matched in this contract if\n', '    ///  there is an issue\n', '    /// @param _escapeHatchCaller The address of a trusted account or contract\n', '    ///  to call `escapeHatch()` to send the ether in this contract to the \n', '    ///  `escapeHatchDestination` it would be ideal that `escapeHatchCaller`\n', '    ///  cannot move funds out of `escapeHatchDestination`\n', '    function MexicoMatcher(\n', '            address _beneficiary, // address that receives ether\n', '            address _escapeHatchCaller,\n', '            address _escapeHatchDestination\n', '        )\n', '        // Set the escape hatch to accept ether (0x0)\n', '        Escapable(0x0, _escapeHatchCaller, _escapeHatchDestination)\n', '    {\n', '        beneficiary = _beneficiary;\n', '    }\n', '    \n', '    /// @notice Simple function to deposit more ETH to match future donations\n', '    function depositETH() payable {\n', '        DonationDeposited4Matching(msg.sender, msg.value);\n', '    }\n', '    /// @notice Donate ETH to the `beneficiary`, and if there is enough in the \n', '    ///  contract double it. The `msg.sender` is rewarded with Campaign tokens;\n', '    ///  This contract may have a high gasLimit requirement\n', '    function () payable {\n', '        uint256 amount;\n', '        \n', '        // If there is enough ETH in the contract to double it, DOUBLE IT!\n', '        if (this.balance >= msg.value*2){\n', '            amount = msg.value*2; // do it two it!\n', '        \n', '            // Send ETH to the beneficiary; must be an account, not a contract\n', '            require (beneficiary.send(amount));\n', '            DonationMatched(msg.sender, amount);\n', '        } else {\n', '            amount = this.balance;\n', '            require (beneficiary.send(amount));\n', '            DonationSentButNotMatched(msg.sender, amount);\n', '        }\n', '    }\n', '    event DonationDeposited4Matching(address indexed sender, uint amount);\n', '    event DonationMatched(address indexed sender, uint amount);\n', '    event DonationSentButNotMatched(address indexed sender, uint amount);\n', '}']
['pragma solidity ^0.4.13;\n', '/*\n', '    Copyright 2017, Griff Green\n', '\n', '    This program is free software: you can redistribute it and/or modify\n', '    it under the terms of the GNU General Public License as published by\n', '    the Free Software Foundation, either version 3 of the License, or\n', '    (at your option) any later version.\n', '\n', '    This program is distributed in the hope that it will be useful,\n', '    but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '    GNU General Public License for more details.\n', '\n', '    You should have received a copy of the GNU General Public License\n', '    along with this program.  If not, see <http://www.gnu.org/licenses/>.\n', ' */\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of BasicToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/// @dev `Escapable` is a base level contract for and contract that wants to\n', '///  add an escape hatch for a contract that holds ETH or ERC20 tokens. This\n', '///  contract creates an `escapeHatch()` function to send its `baseTokens` to\n', '///  `escapeHatchDestination` when called by the `escapeHatchCaller` in the case that\n', '///  something unexpected happens\n', 'contract Escapable {\n', '    BasicToken public baseToken;\n', '\n', '    address public escapeHatchCaller;\n', '    address public escapeHatchDestination;\n', '\n', '    /// @notice The Constructor assigns the `escapeHatchDestination`, the\n', '    ///  `escapeHatchCaller`, and the `baseToken`\n', '    /// @param _baseToken The address of the token that is used as a store value\n', '    ///  for this contract, 0x0 in case of ether. The token must have the ERC20\n', '    ///  standard `balanceOf()` and `transfer()` functions\n', '    /// @param _escapeHatchDestination The address of a safe location (usu a\n', '    ///  Multisig) to send the `baseToken` held in this contract\n', '    /// @param _escapeHatchCaller The address of a trusted account or contract to\n', '    ///  call `escapeHatch()` to send the `baseToken` in this contract to the\n', '    ///  `escapeHatchDestination` it would be ideal that `escapeHatchCaller`\n', '    /// cannot move funds out of `escapeHatchDestination`\n', '    function Escapable(\n', '        address _baseToken,\n', '        address _escapeHatchCaller,\n', '        address _escapeHatchDestination) {\n', '        baseToken = BasicToken(_baseToken);\n', '        escapeHatchCaller = _escapeHatchCaller;\n', '        escapeHatchDestination = _escapeHatchDestination;\n', '    }\n', '\n', '    /// @dev The addresses preassigned the `escapeHatchCaller` role\n', '    ///  is the only addresses that can call a function with this modifier\n', '    modifier onlyEscapeHatchCaller {\n', '        require (msg.sender == escapeHatchCaller);\n', '        _;\n', '    }\n', '\n', '    /// @notice The `escapeHatch()` should only be called as a last resort if a\n', '    /// security issue is uncovered or something unexpected happened\n', '    function escapeHatch() onlyEscapeHatchCaller {\n', '        uint total = getBalance();\n', '        // Send the total balance of this contract to the `escapeHatchDestination`\n', '        transfer(escapeHatchDestination, total);\n', '        EscapeHatchCalled(total);\n', '    }\n', '    /// @notice Changes the address assigned to call `escapeHatch()`\n', '    /// @param _newEscapeHatchCaller The address of a trusted account or contract to\n', '    ///  call `escapeHatch()` to send the ether in this contract to the\n', '    ///  `escapeHatchDestination` it would be ideal that `escapeHatchCaller` cannot\n', '    ///  move funds out of `escapeHatchDestination`\n', '    function changeEscapeHatchCaller(address _newEscapeHatchCaller\n', '        ) onlyEscapeHatchCaller \n', '    {\n', '        escapeHatchCaller = _newEscapeHatchCaller;\n', '        EscapeHatchCallerChanged(escapeHatchCaller);\n', '    }\n', '    /// @notice Returns the balance of the `baseToken` stored in this contract\n', '    function getBalance() constant returns(uint) {\n', '        if (address(baseToken) != 0) {\n', '            return baseToken.balanceOf(this);\n', '        } else {\n', '            return this.balance;\n', '        }\n', '    }\n', '    /// @notice Sends an `_amount` of `baseToken` to `_to` from this contract,\n', '    /// and it can only be called by the contract itself\n', '    /// @param _to The address of the recipient\n', '    /// @param _amount The amount of `baseToken to be sent\n', '    function transfer(address _to, uint _amount) internal {\n', '        if (address(baseToken) != 0) {\n', '            require (baseToken.transfer(_to, _amount));\n', '        } else {\n', '            require ( _to.send(_amount));\n', '        }\n', '    }\n', '\n', '\n', '//////\n', '// Receive Ether\n', '//////\n', '\n', '    /// @notice Called anytime ether is sent to the contract && creates an event\n', '    /// to more easily track the incoming transactions\n', '    function receiveEther() payable {\n', '        // Do not accept ether if baseToken is not ETH\n', '        require (address(baseToken) == 0);\n', '        EtherReceived(msg.sender, msg.value);\n', '    }\n', '\n', '//////////\n', '// Safety Methods\n', '//////////\n', '\n', '    /// @notice This method can be used by the controller to extract mistakenly\n', '    ///  sent tokens to this contract.\n', '    /// @param _token The address of the token contract that you want to recover\n', '    ///  set to 0 in case you want to extract ether.\n', '    function claimTokens(address _token) public onlyEscapeHatchCaller {\n', '        if (_token == 0x0) {\n', '            escapeHatchDestination.transfer(this.balance);\n', '            return;\n', '        }\n', '\n', '        BasicToken token = BasicToken(_token);\n', '        uint256 balance = token.balanceOf(this);\n', '        token.transfer(escapeHatchDestination, balance);\n', '        ClaimedTokens(_token, escapeHatchDestination, balance);\n', '    }\n', '\n', '    /// @notice The fall back function is called whenever ether is sent to this\n', '    ///  contract\n', '    function () payable {\n', '        receiveEther();\n', '    }\n', '\n', '    event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);\n', '    event EscapeHatchCalled(uint amount);\n', '    event EscapeHatchCallerChanged(address indexed newEscapeHatchCaller);\n', '    event EtherReceived(address indexed from, uint amount);\n', '}\n', '\n', '/// @title Mexico Matcher\n', '/// @author Vojtech Simetka, Jordi Baylina, Dani Philia, Arthur Lunn, Griff Green\n', '/// @notice This contract is used to match donations inspired by the generosity\n', '///  of Bitso:  \n', '///  The escapeHatch allows removal of any other tokens deposited by accident.\n', '\n', '\n', '/// @dev The main contract which forwards funds sent to contract.\n', 'contract MexicoMatcher is Escapable {\n', '    address public beneficiary; // expected to be a Giveth campaign\n', '\n', '    /// @notice The Constructor assigns the `beneficiary`, the\n', '    ///  `escapeHatchDestination` and the `escapeHatchCaller` as well as deploys\n', '    ///  the contract to the blockchain (obviously)\n', '    /// @param _beneficiary The address that will receive donations\n', '    /// @param _escapeHatchDestination The address of a safe location (usually a\n', '    ///  Multisig) to send the ether deposited to be matched in this contract if\n', '    ///  there is an issue\n', '    /// @param _escapeHatchCaller The address of a trusted account or contract\n', '    ///  to call `escapeHatch()` to send the ether in this contract to the \n', '    ///  `escapeHatchDestination` it would be ideal that `escapeHatchCaller`\n', '    ///  cannot move funds out of `escapeHatchDestination`\n', '    function MexicoMatcher(\n', '            address _beneficiary, // address that receives ether\n', '            address _escapeHatchCaller,\n', '            address _escapeHatchDestination\n', '        )\n', '        // Set the escape hatch to accept ether (0x0)\n', '        Escapable(0x0, _escapeHatchCaller, _escapeHatchDestination)\n', '    {\n', '        beneficiary = _beneficiary;\n', '    }\n', '    \n', '    /// @notice Simple function to deposit more ETH to match future donations\n', '    function depositETH() payable {\n', '        DonationDeposited4Matching(msg.sender, msg.value);\n', '    }\n', '    /// @notice Donate ETH to the `beneficiary`, and if there is enough in the \n', '    ///  contract double it. The `msg.sender` is rewarded with Campaign tokens;\n', '    ///  This contract may have a high gasLimit requirement\n', '    function () payable {\n', '        uint256 amount;\n', '        \n', '        // If there is enough ETH in the contract to double it, DOUBLE IT!\n', '        if (this.balance >= msg.value*2){\n', '            amount = msg.value*2; // do it two it!\n', '        \n', '            // Send ETH to the beneficiary; must be an account, not a contract\n', '            require (beneficiary.send(amount));\n', '            DonationMatched(msg.sender, amount);\n', '        } else {\n', '            amount = this.balance;\n', '            require (beneficiary.send(amount));\n', '            DonationSentButNotMatched(msg.sender, amount);\n', '        }\n', '    }\n', '    event DonationDeposited4Matching(address indexed sender, uint amount);\n', '    event DonationMatched(address indexed sender, uint amount);\n', '    event DonationSentButNotMatched(address indexed sender, uint amount);\n', '}']