['pragma solidity ^0.4.23;\n', '\n', '// File: contracts/helpers/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '  * @dev The Constructor sets the original owner of the contract to the\n', '  * sender account.\n', '  */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '  * @dev Throws if called by any other account other than owner.\n', '  */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/helpers/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/token/ERC20Interface.sol\n', '\n', 'contract ERC20Interface {\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '\n', '}\n', '\n', '// File: contracts/token/BaseToken.sol\n', '\n', 'contract BaseToken is ERC20Interface {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev Obtain total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    require(_spender != address(0));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '\n', '    emit Transfer(_from, _to, _value);\n', '\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/token/MintableToken.sol\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', 'contract MintableToken is BaseToken, Ownable {\n', '\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '    require(_to != address(0));\n', '\n', '    totalSupply_ = totalSupply_.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    emit Mint(_to, _amount);\n', '    emit Transfer(address(0), _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyOwner canMint public returns (bool) {\n', '    mintingFinished = true;\n', '    emit MintFinished();\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/token/CappedToken.sol\n', '\n', 'contract CappedToken is MintableToken {\n', '\n', '  uint256 public cap;\n', '\n', '  constructor(uint256 _cap) public {\n', '    require(_cap > 0);\n', '    cap = _cap;\n', '  }\n', '\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '    require(totalSupply_.add(_amount) <= cap);\n', '\n', '    return super.mint(_to, _amount);\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/helpers/Pausable.sol\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/token/PausableToken.sol\n', '\n', '/**\n', ' * @title Pausable token\n', ' * @dev BaseToken modified with pausable transfers.\n', ' **/\n', 'contract PausableToken is BaseToken, Pausable {\n', '\n', '  function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.approve(_spender, _value);\n', '  }\n', '\n', '  function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {\n', '    return super.increaseApproval(_spender, _addedValue);\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {\n', '    return super.decreaseApproval(_spender, _subtractedValue);\n', '  }\n', '}\n', '\n', '// File: contracts/token/SignedTransferToken.sol\n', '\n', '/**\n', '* @title SignedTransferToken\n', '* @dev The SignedTransferToken enables collection of fees for token transfers\n', '* in native token currency. User will provide a signature that allows the third\n', '* party to settle the transaction in his name and collect fee for provided\n', '* serivce.\n', '*/\n', 'contract SignedTransferToken is BaseToken {\n', '\n', '  event TransferPreSigned(\n', '    address indexed from,\n', '    address indexed to,\n', '    address indexed settler,\n', '    uint256 value,\n', '    uint256 fee\n', '  );\n', '\n', '\n', '  // Mapping of already executed settlements for a given address\n', '  mapping(address => mapping(bytes32 => bool)) internal executedSettlements;\n', '\n', '  /**\n', '  * @dev Will settle a pre-signed transfer\n', '  */\n', '  function transferPreSigned(address _from,\n', '                             address _to,\n', '                             uint256 _value,\n', '                             uint256 _fee,\n', '                             uint256 _nonce,\n', '                             uint8 _v,\n', '                             bytes32 _r,\n', '                             bytes32 _s) public returns (bool) {\n', '    uint256 total = _value.add(_fee);\n', '    bytes32 calcHash = calculateHash(_from, _to, _value, _fee, _nonce);\n', '\n', '    require(_to != address(0));\n', '    require(isValidSignature(_from, calcHash, _v, _r, _s));\n', '    require(balances[_from] >= total);\n', '    require(!executedSettlements[_from][calcHash]);\n', '\n', '    executedSettlements[_from][calcHash] = true;\n', '\n', '    // Move tokens\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(_from, _to, _value);\n', '\n', '    // Move fee\n', '    balances[_from] = balances[_from].sub(_fee);\n', '    balances[msg.sender] = balances[msg.sender].add(_fee);\n', '    emit Transfer(_from, msg.sender, _fee);\n', '\n', '    emit TransferPreSigned(_from, _to, msg.sender, _value, _fee);\n', '\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Settle multiple transactions in a single call. Please note that\n', '  * should a single one fail the full state will be reverted. Your client\n', '  * implementation should always first check for balances, correct signatures\n', '  * and any other conditions that might result in failed transaction.\n', '  */\n', '  function transferPreSignedBulk(address[] _from,\n', '                                 address[] _to,\n', '                                 uint256[] _values,\n', '                                 uint256[] _fees,\n', '                                 uint256[] _nonces,\n', '                                 uint8[] _v,\n', '                                 bytes32[] _r,\n', '                                 bytes32[] _s) public returns (bool) {\n', '    // Make sure all the arrays are of the same length\n', '    require(_from.length == _to.length &&\n', '            _to.length ==_values.length &&\n', '            _values.length == _fees.length &&\n', '            _fees.length == _nonces.length &&\n', '            _nonces.length == _v.length &&\n', '            _v.length == _r.length &&\n', '            _r.length == _s.length);\n', '\n', '    for(uint i; i < _from.length; i++) {\n', '      transferPreSigned(_from[i],\n', '                        _to[i],\n', '                        _values[i],\n', '                        _fees[i],\n', '                        _nonces[i],\n', '                        _v[i],\n', '                        _r[i],\n', '                        _s[i]);\n', '    }\n', '\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Calculates transfer hash.\n', '  */\n', '  function calculateHash(address _from, address _to, uint256 _value, uint256 _fee, uint256 _nonce) public view returns (bytes32) {\n', '    return keccak256(abi.encodePacked(uint256(0), address(this), _from, _to, _value, _fee, _nonce));\n', '  }\n', '\n', '  /**\n', '  * @dev Validates the signature\n', '  */\n', '  function isValidSignature(address _signer, bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) public pure returns (bool) {\n', '    return _signer == ecrecover(\n', '            keccak256(abi.encodePacked("\\x19Ethereum Signed Message:\\n32", _hash)),\n', '            _v,\n', '            _r,\n', '            _s\n', '        );\n', '  }\n', '\n', '  /**\n', '  * @dev Allows you to check whether a certain transaction has been already\n', '  * settled or not.\n', '  */\n', '  function isTransactionAlreadySettled(address _from, bytes32 _calcHash) public view returns (bool) {\n', '    return executedSettlements[_from][_calcHash];\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/token/PausableSignedTransferToken.sol\n', '\n', 'contract PausableSignedTransferToken is SignedTransferToken, PausableToken {\n', '\n', '  function transferPreSigned(address _from,\n', '                             address _to,\n', '                             uint256 _value,\n', '                             uint256 _fee,\n', '                             uint256 _nonce,\n', '                             uint8 _v,\n', '                             bytes32 _r,\n', '                             bytes32 _s) public whenNotPaused returns (bool) {\n', '    return super.transferPreSigned(_from, _to, _value, _fee, _nonce, _v, _r, _s);\n', '  }\n', '\n', '  function transferPreSignedBulk(address[] _from,\n', '                                 address[] _to,\n', '                                 uint256[] _values,\n', '                                 uint256[] _fees,\n', '                                 uint256[] _nonces,\n', '                                 uint8[] _v,\n', '                                 bytes32[] _r,\n', '                                 bytes32[] _s) public whenNotPaused returns (bool) {\n', '    return super.transferPreSignedBulk(_from, _to, _values, _fees, _nonces, _v, _r, _s);\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/ElesToken.sol\n', '\n', 'contract ElesToken is CappedToken, PausableSignedTransferToken  {\n', '  string public name = &#39;Elements Estates Token&#39;;\n', '  string public symbol = &#39;ELES&#39;;\n', '  uint256 public decimals = 18;\n', '\n', '\n', '  // Max supply of 250 million\n', '  uint256 internal maxSupply = 250000000 * 10**decimals;\n', '\n', '  constructor()\n', '   CappedToken(maxSupply) public {\n', '      paused = true;\n', '  }\n', '\n', '  // @dev Recover any mistakenly sent ERC20 tokens to the Token address\n', '  function recoverERC20Tokens(address _erc20, uint256 _amount) public onlyOwner {\n', '    ERC20Interface(_erc20).transfer(msg.sender, _amount);\n', '  }\n', '\n', '}']
['pragma solidity ^0.4.23;\n', '\n', '// File: contracts/helpers/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '  * @dev The Constructor sets the original owner of the contract to the\n', '  * sender account.\n', '  */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '  * @dev Throws if called by any other account other than owner.\n', '  */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/helpers/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/token/ERC20Interface.sol\n', '\n', 'contract ERC20Interface {\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '\n', '}\n', '\n', '// File: contracts/token/BaseToken.sol\n', '\n', 'contract BaseToken is ERC20Interface {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev Obtain total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    require(_spender != address(0));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '\n', '    emit Transfer(_from, _to, _value);\n', '\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/token/MintableToken.sol\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', 'contract MintableToken is BaseToken, Ownable {\n', '\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '    require(_to != address(0));\n', '\n', '    totalSupply_ = totalSupply_.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    emit Mint(_to, _amount);\n', '    emit Transfer(address(0), _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyOwner canMint public returns (bool) {\n', '    mintingFinished = true;\n', '    emit MintFinished();\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/token/CappedToken.sol\n', '\n', 'contract CappedToken is MintableToken {\n', '\n', '  uint256 public cap;\n', '\n', '  constructor(uint256 _cap) public {\n', '    require(_cap > 0);\n', '    cap = _cap;\n', '  }\n', '\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '    require(totalSupply_.add(_amount) <= cap);\n', '\n', '    return super.mint(_to, _amount);\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/helpers/Pausable.sol\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/token/PausableToken.sol\n', '\n', '/**\n', ' * @title Pausable token\n', ' * @dev BaseToken modified with pausable transfers.\n', ' **/\n', 'contract PausableToken is BaseToken, Pausable {\n', '\n', '  function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.approve(_spender, _value);\n', '  }\n', '\n', '  function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {\n', '    return super.increaseApproval(_spender, _addedValue);\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {\n', '    return super.decreaseApproval(_spender, _subtractedValue);\n', '  }\n', '}\n', '\n', '// File: contracts/token/SignedTransferToken.sol\n', '\n', '/**\n', '* @title SignedTransferToken\n', '* @dev The SignedTransferToken enables collection of fees for token transfers\n', '* in native token currency. User will provide a signature that allows the third\n', '* party to settle the transaction in his name and collect fee for provided\n', '* serivce.\n', '*/\n', 'contract SignedTransferToken is BaseToken {\n', '\n', '  event TransferPreSigned(\n', '    address indexed from,\n', '    address indexed to,\n', '    address indexed settler,\n', '    uint256 value,\n', '    uint256 fee\n', '  );\n', '\n', '\n', '  // Mapping of already executed settlements for a given address\n', '  mapping(address => mapping(bytes32 => bool)) internal executedSettlements;\n', '\n', '  /**\n', '  * @dev Will settle a pre-signed transfer\n', '  */\n', '  function transferPreSigned(address _from,\n', '                             address _to,\n', '                             uint256 _value,\n', '                             uint256 _fee,\n', '                             uint256 _nonce,\n', '                             uint8 _v,\n', '                             bytes32 _r,\n', '                             bytes32 _s) public returns (bool) {\n', '    uint256 total = _value.add(_fee);\n', '    bytes32 calcHash = calculateHash(_from, _to, _value, _fee, _nonce);\n', '\n', '    require(_to != address(0));\n', '    require(isValidSignature(_from, calcHash, _v, _r, _s));\n', '    require(balances[_from] >= total);\n', '    require(!executedSettlements[_from][calcHash]);\n', '\n', '    executedSettlements[_from][calcHash] = true;\n', '\n', '    // Move tokens\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(_from, _to, _value);\n', '\n', '    // Move fee\n', '    balances[_from] = balances[_from].sub(_fee);\n', '    balances[msg.sender] = balances[msg.sender].add(_fee);\n', '    emit Transfer(_from, msg.sender, _fee);\n', '\n', '    emit TransferPreSigned(_from, _to, msg.sender, _value, _fee);\n', '\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Settle multiple transactions in a single call. Please note that\n', '  * should a single one fail the full state will be reverted. Your client\n', '  * implementation should always first check for balances, correct signatures\n', '  * and any other conditions that might result in failed transaction.\n', '  */\n', '  function transferPreSignedBulk(address[] _from,\n', '                                 address[] _to,\n', '                                 uint256[] _values,\n', '                                 uint256[] _fees,\n', '                                 uint256[] _nonces,\n', '                                 uint8[] _v,\n', '                                 bytes32[] _r,\n', '                                 bytes32[] _s) public returns (bool) {\n', '    // Make sure all the arrays are of the same length\n', '    require(_from.length == _to.length &&\n', '            _to.length ==_values.length &&\n', '            _values.length == _fees.length &&\n', '            _fees.length == _nonces.length &&\n', '            _nonces.length == _v.length &&\n', '            _v.length == _r.length &&\n', '            _r.length == _s.length);\n', '\n', '    for(uint i; i < _from.length; i++) {\n', '      transferPreSigned(_from[i],\n', '                        _to[i],\n', '                        _values[i],\n', '                        _fees[i],\n', '                        _nonces[i],\n', '                        _v[i],\n', '                        _r[i],\n', '                        _s[i]);\n', '    }\n', '\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Calculates transfer hash.\n', '  */\n', '  function calculateHash(address _from, address _to, uint256 _value, uint256 _fee, uint256 _nonce) public view returns (bytes32) {\n', '    return keccak256(abi.encodePacked(uint256(0), address(this), _from, _to, _value, _fee, _nonce));\n', '  }\n', '\n', '  /**\n', '  * @dev Validates the signature\n', '  */\n', '  function isValidSignature(address _signer, bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) public pure returns (bool) {\n', '    return _signer == ecrecover(\n', '            keccak256(abi.encodePacked("\\x19Ethereum Signed Message:\\n32", _hash)),\n', '            _v,\n', '            _r,\n', '            _s\n', '        );\n', '  }\n', '\n', '  /**\n', '  * @dev Allows you to check whether a certain transaction has been already\n', '  * settled or not.\n', '  */\n', '  function isTransactionAlreadySettled(address _from, bytes32 _calcHash) public view returns (bool) {\n', '    return executedSettlements[_from][_calcHash];\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/token/PausableSignedTransferToken.sol\n', '\n', 'contract PausableSignedTransferToken is SignedTransferToken, PausableToken {\n', '\n', '  function transferPreSigned(address _from,\n', '                             address _to,\n', '                             uint256 _value,\n', '                             uint256 _fee,\n', '                             uint256 _nonce,\n', '                             uint8 _v,\n', '                             bytes32 _r,\n', '                             bytes32 _s) public whenNotPaused returns (bool) {\n', '    return super.transferPreSigned(_from, _to, _value, _fee, _nonce, _v, _r, _s);\n', '  }\n', '\n', '  function transferPreSignedBulk(address[] _from,\n', '                                 address[] _to,\n', '                                 uint256[] _values,\n', '                                 uint256[] _fees,\n', '                                 uint256[] _nonces,\n', '                                 uint8[] _v,\n', '                                 bytes32[] _r,\n', '                                 bytes32[] _s) public whenNotPaused returns (bool) {\n', '    return super.transferPreSignedBulk(_from, _to, _values, _fees, _nonces, _v, _r, _s);\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/ElesToken.sol\n', '\n', 'contract ElesToken is CappedToken, PausableSignedTransferToken  {\n', "  string public name = 'Elements Estates Token';\n", "  string public symbol = 'ELES';\n", '  uint256 public decimals = 18;\n', '\n', '\n', '  // Max supply of 250 million\n', '  uint256 internal maxSupply = 250000000 * 10**decimals;\n', '\n', '  constructor()\n', '   CappedToken(maxSupply) public {\n', '      paused = true;\n', '  }\n', '\n', '  // @dev Recover any mistakenly sent ERC20 tokens to the Token address\n', '  function recoverERC20Tokens(address _erc20, uint256 _amount) public onlyOwner {\n', '    ERC20Interface(_erc20).transfer(msg.sender, _amount);\n', '  }\n', '\n', '}']
