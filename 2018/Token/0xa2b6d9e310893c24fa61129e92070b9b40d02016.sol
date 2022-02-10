['pragma solidity ^0.4.18;\n', '\n', '// https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol\n', 'library SafeMath {\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/ownership/Ownable.sol\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', '// https://github.com/ethereum/EIPs/issues/179\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// https://github.com/ethereum/EIPs/issues/20\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/DetailedERC20.sol\n', 'contract DetailedERC20 is ERC20 {\n', '  string public name;\n', '  string public symbol;\n', '  uint8 public decimals;\n', '\n', '  function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {\n', '    name = _name;\n', '    symbol = _symbol;\n', '    decimals = _decimals;\n', '  }\n', '}\n', '\n', '// RoyalForkToken has the following properties:\n', '// - users create an "account", which consists of a unique username, and token count.\n', '// - tokens are minted at the discretion of "owner" and "minter".\n', '// - tokens can only be transferred to existing token holders.\n', '// - each token holder is entitled to a share of all donations sent to contract \n', '//   on a per-month basis and regardless of total token holdings; a dividend. \n', '//   (eg: 10 eth is sent to the contract in January.  There are 100 token \n', '//   holders on Jan 31.  At any time in February, each token holder can \n', '//   withdraw .1 eth for their January share).\n', '// - dividends not collected for a given month become donations for the next month.\n', 'contract RoyalForkToken is Ownable, DetailedERC20("RoyalForkToken", "RFT", 0) {\n', '  using SafeMath for uint256;\n', '\n', '  struct Hodler {\n', '    bytes16 username;\n', '    uint64 balance;\n', '    uint16 canWithdrawPeriod;\n', '  }\n', '\n', '  mapping(address => Hodler) public hodlers;\n', '  mapping(bytes16 => address) public usernames;\n', '\n', '  uint256 public epoch = now;\n', '  uint16 public currentPeriod = 1;\n', '  uint64 public numHodlers;\n', '  uint64 public prevHodlers;\n', '  uint256 public prevBalance;\n', '\n', '  address minter;\n', '\n', '  mapping(address => mapping (address => uint256)) internal allowed;\n', '\n', '  event Mint(address indexed to, uint256 amount);\n', '  event PeriodEnd(uint16 indexed period, uint256 amount, uint64 hodlers);\n', '  event Donation(address indexed from, uint256 amount);\n', '  event Withdrawal(address indexed to, uint16 indexed period, uint256 amount);\n', '\n', '  modifier onlyMinter() {\n', '    require(msg.sender == minter);\n', '    _;\n', '  }\n', '\n', '  // === Private Functions\n', '  // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/ECRecovery.sol\n', '  function recover(bytes32 hash, bytes sig) internal pure returns (address) {\n', '    bytes32 r;\n', '    bytes32 s;\n', '    uint8 v;\n', '\n', '    //Check the signature length\n', '    if (sig.length != 65) {\n', '      return (address(0));\n', '    }\n', '\n', '    // Divide the signature in r, s and v variables\n', '    assembly {\n', '      r := mload(add(sig, 32))\n', '      s := mload(add(sig, 64))\n', '      v := byte(0, mload(add(sig, 96)))\n', '    }\n', '\n', '    // Version of signature should be 27 or 28, but 0 and 1 are also possible versions\n', '    if (v < 27) {\n', '      v += 27;\n', '    }\n', '\n', '    // If the version is correct return the signer address\n', '    if (v != 27 && v != 28) {\n', '      return (address(0));\n', '    } else {\n', '      return ecrecover(hash, v, r, s);\n', '    }\n', '  }\n', '\n', "  // Ensures that username isn't taken, and account doesn't already exist for \n", "  // user's address.\n", '  function newHodler(address user, bytes16 username, uint64 endowment) private {\n', '    require(usernames[username] == address(0));\n', '    require(hodlers[user].canWithdrawPeriod == 0);\n', '\n', '    hodlers[user].canWithdrawPeriod = currentPeriod;\n', '    hodlers[user].balance = endowment;\n', '    hodlers[user].username = username;\n', '    usernames[username] = user;\n', '\n', '    numHodlers += 1;\n', '    totalSupply += endowment;\n', '    Mint(user, endowment);\n', '  }\n', '\n', '  // === Owner Functions\n', '  function setMinter(address newMinter) public onlyOwner {\n', '    minter = newMinter;\n', '  }\n', '\n', '  // Owner should call this on 1st of every month.\n', '  function newPeriod() public onlyOwner {\n', '    require(now >= epoch + 28 days);\n', '    currentPeriod++;\n', '    prevHodlers = numHodlers;\n', '    prevBalance = this.balance;\n', '    PeriodEnd(currentPeriod-1, prevBalance, prevHodlers);\n', '  }\n', '\n', '  // === Minter Functions\n', '  function createHodler(address to, bytes16 username, uint64 amount) public onlyMinter {\n', '    newHodler(to, username, amount);\n', '  }\n', '\n', '  // Send tokens to existing account.\n', '  function mint(address user, uint64 amount) public onlyMinter {\n', '    require(hodlers[user].canWithdrawPeriod != 0);\n', '    require(hodlers[user].balance + amount > hodlers[user].balance);\n', '\n', '    hodlers[user].balance += amount;\n', '    totalSupply += amount;\n', '    Mint(user, amount);\n', '  }\n', '\n', '  // === User Functions\n', '  // Owner will sign hash(amount, address), and address owner uses this \n', '  // signature to create their account.\n', '  function create(bytes16 username, uint64 endowment, bytes sig) public {\n', '    require(recover(keccak256(endowment, msg.sender), sig) == owner);\n', '    newHodler(msg.sender, username, endowment);\n', '  }\n', '\n', '  // User can withdraw their share of donations from the previous month.\n', '  function withdraw() public {\n', '    require(hodlers[msg.sender].canWithdrawPeriod != 0);\n', '    require(hodlers[msg.sender].canWithdrawPeriod < currentPeriod);\n', '\n', '    hodlers[msg.sender].canWithdrawPeriod = currentPeriod;\n', '    uint256 payment = prevBalance / prevHodlers;\n', '    prevHodlers -= 1;\n', '    prevBalance -= payment;\n', '    msg.sender.send(payment);\n', '    Withdrawal(msg.sender, currentPeriod-1, payment);\n', '  }\n', '\n', '  // ERC20 Functions\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return hodlers[_owner].balance;\n', '  }\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(hodlers[_to].canWithdrawPeriod != 0);\n', '    require(_value <= hodlers[msg.sender].balance);\n', '    require(hodlers[_to].balance + uint64(_value) > hodlers[_to].balance);\n', '\n', '    hodlers[msg.sender].balance -= uint64(_value);\n', '    hodlers[_to].balance += uint64(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(hodlers[_to].canWithdrawPeriod != 0);\n', '    require(_value <= hodlers[_from].balance);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '    require(hodlers[_to].balance + uint64(_value) > hodlers[_to].balance);\n', '\n', '    hodlers[_from].balance -= uint64(_value);\n', '    hodlers[_to].balance += uint64(_value);\n', '    allowed[_from][msg.sender] -= _value;\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  // === Constructor/Default\n', '  function RoyalForkToken() public {\n', '    minter = msg.sender;\n', '  }\n', '\n', '  function() payable public {\n', '    Donation(msg.sender, msg.value);\n', '  }\n', '}']