['pragma solidity ^0.4.18;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract HasNoEther is Ownable {\n', '\n', '  /**\n', '  * @dev Constructor that rejects incoming Ether\n', '  * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we\n', '  * leave out payable, then Solidity will allow inheriting contracts to implement a payable\n', '  * constructor. By doing it this way we prevent a payable constructor from working. Alternatively\n', '  * we could use assembly to access msg.value.\n', '  */\n', '  function HasNoEther() public payable {\n', '    require(msg.value == 0);\n', '  }\n', '\n', '  /**\n', '   * @dev Disallows direct send by settings a default function without the `payable` flag.\n', '   */\n', '  function() external {\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer all Ether held by the contract to the owner.\n', '   */\n', '  function reclaimEther() external onlyOwner {\n', '    address myaddress = this;\n', '    assert(owner.send(myaddress.balance));\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function getaddress0() public view returns (address);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  function getaddress0() public view returns (address){\n', '    return address(0);\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', 'contract BurnableToken is StandardToken {\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    /**\n', '     * @dev Burns a specific amount of tokens.\n', '     * @param _value The amount of token to be burned.\n', '     */\n', '    function burn(uint256 _value) public {\n', '        require(_value > 0);\n', '        require(_value <= balances[msg.sender]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', '        // sender&#39;s balance is greater than the totalSupply, which *should* be an assertion failure\n', '\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        emit Burn(burner, _value);\n', '    }\n', '}\n', '\n', 'contract CoinmakeToken is BurnableToken, HasNoEther {\n', '\n', '    string public constant name = "Coinmake Token";\n', '\n', '    string public constant symbol = "CT";\n', '\n', '    uint8 public constant decimals = 18;\n', '\n', '    uint256 constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));\n', '\n', '    /**\n', '    * @dev Constructor that gives msg.sender all of existing tokens.\n', '    */\n', '    function CoinmakeToken() public {\n', '        totalSupply = INITIAL_SUPPLY;\n', '        balances[msg.sender] = INITIAL_SUPPLY;\n', '        emit Transfer(address(0), msg.sender, totalSupply);\n', '    }\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer tokens from one address to another\n', '    * @param _from address The address which you want to send tokens from\n', '    * @param _to address The address which you want to transfer to\n', '    * @param _value uint256 the amount of tokens to be transferred\n', '    */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function multiTransfer(address[] recipients, uint256[] amounts) public {\n', '        require(recipients.length == amounts.length);\n', '        for (uint i = 0; i < recipients.length; i++) {\n', '            transfer(recipients[i], amounts[i]);\n', '        }\n', '    }\n', '}']