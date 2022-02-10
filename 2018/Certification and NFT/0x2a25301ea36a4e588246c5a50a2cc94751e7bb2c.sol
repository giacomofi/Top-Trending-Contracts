['/**\n', ' * This smart contract code is Copyright 2018 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '\n', '// EtherScan verify workaround test\n', '// pragma solidity ^0.4.18;\n', '\n', '\n', '/**\n', ' * @dev Split ether between parties.\n', ' * @author TokenMarket Ltd. /  Ville Sundell <ville at tokenmarket.net>\n', ' *\n', ' * Allows splitting payments between parties.\n', ' * Ethers are split to parties, each party has slices they are entitled to.\n', ' * Ethers of this smart contract are divided into slices upon split().\n', ' */\n', '\n', '/**\n', ' * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', 'contract Recoverable is Ownable {\n', '\n', '  /// @dev Empty constructor (for now)\n', '  function Recoverable() {\n', '  }\n', '\n', '  /// @dev This will be invoked by the owner, when owner wants to rescue tokens\n', '  /// @param token Token which will we rescue to the owner from the contract\n', '  function recoverTokens(ERC20Basic token) onlyOwner public {\n', '    token.transfer(owner, tokensToBeReturned(token));\n', '  }\n', '\n', '  /// @dev Interface function, can be overwritten by the superclass\n', '  /// @param token Token which balance we will check and return\n', '  /// @return The amount of tokens (in smallest denominator) the contract owns\n', '  function tokensToBeReturned(ERC20Basic token) public returns (uint) {\n', '    return token.balanceOf(this);\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', 'contract PaymentSplitter is Recoverable {\n', '  using SafeMath for uint256; // We use only uint256 for safety reasons (no boxing)\n', '\n', '  /// @dev Describes a party (address and amount of slices the party is entitled to)\n', '  struct Party {\n', '    address addr;\n', '    uint256 slices;\n', '  }\n', '\n', "  /// @dev This is just a failsafe, so we can't initialize a contract where\n", '  ///      splitting would not be succesful in the future (for example because\n', '  ///      of decreased block gas limit):\n', '  uint256 constant MAX_PARTIES = 100;\n', '  /// @dev How many slices there are in total:\n', '  uint256 public totalSlices;\n', '  /// @dev Array of "Party"s for each party\'s address and amount of slices:\n', '  Party[] public parties;\n', '\n', '  /// @dev This event is emitted when someone makes a payment:\n', '  ///      (Gnosis MultiSigWallet compatible event)\n', '  event Deposit(address indexed sender, uint256 value);\n', '  /// @dev This event is emitted when someone splits the ethers between parties:\n', '  ///      (emitted once per call)\n', '  event Split(address indexed who, uint256 value);\n', '  /// @dev This event is emitted for every party we send ethers to:\n', '  event SplitTo(address indexed to, uint256 value);\n', '\n', '  /// @dev Constructor: takes list of parties and their slices.\n', '  /// @param addresses List of addresses of the parties\n', '  /// @param slices Slices of the parties. Will be added to totalSlices.\n', '  function PaymentSplitter(address[] addresses, uint[] slices) public {\n', '    require(addresses.length == slices.length, "addresses and slices must be equal length.");\n', '    require(addresses.length > 0 && addresses.length < MAX_PARTIES, "Amount of parties is either too many, or zero.");\n', '\n', '    for(uint i=0; i<addresses.length; i++) {\n', '      parties.push(Party(addresses[i], slices[i]));\n', '      totalSlices = totalSlices.add(slices[i]);\n', '    }\n', '  }\n', '\n', '  /// @dev Split the ethers, and send to parties according to slices.\n', '  ///      This can be intentionally invoked by anyone: if some random person\n', "  ///      wants to pay for the gas, that's good for us.\n", '  function split() external {\n', '    uint256 totalBalance = this.balance;\n', '    uint256 slice = totalBalance.div(totalSlices);\n', '\n', '    for(uint i=0; i<parties.length; i++) {\n', '      uint256 amount = slice.mul(parties[i].slices);\n', '\n', '      parties[i].addr.send(amount);\n', '      emit SplitTo(parties[i].addr, amount);\n', '    }\n', '\n', '    emit Split(msg.sender, totalBalance);\n', '  }\n', '\n', '  /// @dev Fallback function, intentionally designed to fit to the gas stipend.\n', '  function() public payable {\n', '    emit Deposit(msg.sender, msg.value);\n', '  }\n', '}']