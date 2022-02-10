['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract PullPayment {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) public payments;\n', '  uint256 public totalPayments;\n', '\n', '  /**\n', '  * @dev withdraw accumulated balance, called by payee.\n', '  */\n', '  function withdrawPayments() public {\n', '    address payee = msg.sender;\n', '    uint256 payment = payments[payee];\n', '\n', '    require(payment != 0);\n', '    require(this.balance >= payment);\n', '\n', '    totalPayments = totalPayments.sub(payment);\n', '    payments[payee] = 0;\n', '\n', '    assert(payee.send(payment));\n', '  }\n', '\n', '  /**\n', '  * @dev Called by the payer to store the sent amount as credit to be pulled.\n', '  * @param dest The destination address of the funds.\n', '  * @param amount The amount to transfer.\n', '  */\n', '  function asyncSend(address dest, uint256 amount) internal {\n', '    payments[dest] = payments[dest].add(amount);\n', '    totalPayments = totalPayments.add(amount);\n', '  }\n', '}\n', '\n', 'contract EtherPizza is Ownable, PullPayment {\n', '\n', '    address public pizzaHolder;\n', '    uint256 public pizzaPrice;\n', '\n', '    function EtherPizza() public {\n', '        pizzaHolder = msg.sender;\n', '        pizzaPrice = 100000000000000000; // 0.1 ETH initial price\n', '    }\n', '\n', '    function gimmePizza() external payable {\n', '        require(msg.value >= pizzaPrice);\n', '        require(msg.sender != pizzaHolder);\n', '        uint taxesAreSick = msg.value.div(100);\n', '        uint hodlerPrize = msg.value.sub(taxesAreSick);\n', '        asyncSend(pizzaHolder, hodlerPrize);\n', '        asyncSend(owner, taxesAreSick);\n', '        pizzaHolder = msg.sender;\n', '        pizzaPrice = pizzaPrice.mul(2);\n', '    }\n', '\n', '\n', '}']