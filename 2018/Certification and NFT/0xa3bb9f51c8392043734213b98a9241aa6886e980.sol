['pragma solidity ^0.4.21;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    /**\n', '     * mul \n', '     * @dev Safe math multiply function\n', '     */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '  /**\n', '   * add\n', '   * @dev Safe math addition function\n', '   */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev Ownable has an owner address to simplify "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  /**\n', '   * Ownable\n', '   * @dev Ownable constructor sets the `owner` of the contract to sender\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * ownerOnly\n', '   * @dev Throws an error if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * transferOwnership\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Token\n', ' * @dev API interface for interacting with the WILD Token contract \n', ' */\n', 'interface Token {\n', '  function transfer(address _to, uint256 _value) external returns (bool);\n', '  function balanceOf(address _owner) external constant returns (uint256 balance);\n', '}\n', '\n', '/**\n', ' * @title LavevelICO\n', ' * @dev LavevelICO contract is Ownable\n', ' **/\n', 'contract GooglierICO is Ownable {\n', '  using SafeMath for uint256;\n', '  Token token;\n', '\n', '  uint256 public constant RATE = 3000; // Number of tokens per Ether\n', '  uint256 public constant CAP = 5350; // Cap in Ether\n', '  uint256 public constant START = 1519862400; // Mar 26, 2018 @ 12:00 EST\n', '  uint256 public constant DAYS = 45; // 45 Day\n', '  \n', '  uint256 public constant initialTokens = 6000000 * 10**18; // Initial number of tokens available\n', '  bool public initialized = false;\n', '  uint256 public raisedAmount = 0;\n', '  \n', '  /**\n', '   * BoughtTokens\n', '   * @dev Log tokens bought onto the blockchain\n', '   */\n', '  event BoughtTokens(address indexed to, uint256 value);\n', '\n', '  /**\n', '   * whenSaleIsActive\n', '   * @dev ensures that the contract is still active\n', '   **/\n', '  modifier whenSaleIsActive() {\n', '    // Check if sale is active\n', '    assert(isActive());\n', '    _;\n', '  }\n', '  \n', '  /**\n', '   * LavevelICO\n', '   * @dev LavevelICO constructor\n', '   **/\n', '  function LavevelICO(address _tokenAddr) public {\n', '      require(_tokenAddr != 0);\n', '      token = Token(_tokenAddr);\n', '  }\n', '  \n', '  /**\n', '   * initialize\n', '   * @dev Initialize the contract\n', '   **/\n', '  function initialize() public onlyOwner {\n', '      require(initialized == false); // Can only be initialized once\n', '      require(tokensAvailable() == initialTokens); // Must have enough tokens allocated\n', '      initialized = true;\n', '  }\n', '\n', '  /**\n', '   * isActive\n', '   * @dev Determins if the contract is still active\n', '   **/\n', '  function isActive() public view returns (bool) {\n', '    return (\n', '        initialized == true &&\n', '        now >= START && // Must be after the START date\n', '        now <= START.add(DAYS * 1 days) && // Must be before the end date\n', '        goalReached() == false // Goal must not already be reached\n', '    );\n', '  }\n', '\n', '  /**\n', '   * goalReached\n', '   * @dev Function to determin is goal has been reached\n', '   **/\n', '  function goalReached() public view returns (bool) {\n', '    return (raisedAmount >= CAP * 1 ether);\n', '  }\n', '\n', '  /**\n', '   * @dev Fallback function if ether is sent to address insted of buyTokens function\n', '   **/\n', '  function () public payable {\n', '    buyTokens();\n', '  }\n', '\n', '  /**\n', '   * buyTokens\n', '   * @dev function that sells available tokens\n', '   **/\n', '  function buyTokens() public payable whenSaleIsActive {\n', '    uint256 weiAmount = msg.value; // Calculate tokens to sell\n', '    uint256 tokens = weiAmount.mul(RATE);\n', '    \n', '    emit BoughtTokens(msg.sender, tokens); // log event onto the blockchain\n', '    raisedAmount = raisedAmount.add(msg.value); // Increment raised amount\n', '    token.transfer(msg.sender, tokens); // Send tokens to buyer\n', '    \n', '    owner.transfer(msg.value);// Send money to owner\n', '  }\n', '\n', '  /**\n', '   * tokensAvailable\n', '   * @dev returns the number of tokens allocated to this contract\n', '   **/\n', '  function tokensAvailable() public constant returns (uint256) {\n', '    return token.balanceOf(this);\n', '  }\n', '\n', '  /**\n', '   * destroy\n', '   * @notice Terminate contract and refund to owner\n', '   **/\n', '  function destroy() onlyOwner public {\n', '    // Transfer tokens back to owner\n', '    uint256 balance = token.balanceOf(this);\n', '    assert(balance > 0);\n', '    token.transfer(owner, balance);\n', '    // There should be no ether in the contract but just in case\n', '    selfdestruct(owner);\n', '  }\n', '}']