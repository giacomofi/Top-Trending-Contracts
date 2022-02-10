['// File: contracts/Ownerable.sol\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', 'contract Ownerable {\n', '    /// @notice The address of the owner is the only address that can call\n', '    ///  a function with this modifier\n', '    modifier onlyOwner { require(msg.sender == owner); _; }\n', '\n', '    address public owner;\n', '\n', '    constructor() public { owner = msg.sender;}\n', '\n', '    /// @notice Changes the owner of the contract\n', '    /// @param _newOwner The new owner of the contract\n', '    function setOwner(address _newOwner) public onlyOwner {\n', '        owner = _newOwner;\n', '    }\n', '}\n', '\n', '// File: contracts/math/SafeMath.sol\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'contract SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '}\n', '\n', '// File: contracts/token/ERC20Basic.sol\n', '\n', 'pragma solidity ^0.4.18;\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: contracts/token/ERC20.sol\n', '\n', 'pragma solidity ^0.4.18;\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: contracts/token/SafeERC20.sol\n', '\n', 'pragma solidity ^0.4.18;\n', '\n', '\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '  function safeTransfer(ERC20Basic token, address to, uint256 value) internal {\n', '    assert(token.transfer(to, value));\n', '  }\n', '\n', '  function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {\n', '    assert(token.transferFrom(from, to, value));\n', '  }\n', '\n', '  function safeApprove(ERC20 token, address spender, uint256 value) internal {\n', '    assert(token.approve(spender, value));\n', '  }\n', '}\n', '\n', '// File: contracts/locker/TeamLocker.sol\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', '\n', '\n', '\n', '\n', 'contract TeamLocker is Ownerable, SafeMath {\n', '  using SafeERC20 for ERC20Basic;\n', '\n', '  ERC20Basic public token;\n', '  address[] public beneficiaries;\n', '  uint256 public baiastm;\n', '  uint256 public releasedAmt;\n', '\n', '  constructor (address _token, address[] _beneficiaries, uint256 _baias) {\n', '    require(_token != 0x00);\n', '    require(_baias != 0x00);\n', '\n', '    for (uint i = 0; i < _beneficiaries.length; i++) {\n', '      require(_beneficiaries[i] != 0x00);\n', '    }\n', '\n', '    token = ERC20Basic(_token);\n', '    beneficiaries = _beneficiaries;\n', '    baiastm = _baias;\n', '  }\n', '\n', '  function release() public {\n', '    require(beneficiaries.length != 0x0);\n', '\n', '    uint256 balance = token.balanceOf(address(this));\n', '    uint256 total = add(balance, releasedAmt);\n', '\n', '    uint256 lockTime1 = add(baiastm, 183 days); // 6 months\n', '    uint256 lockTime2 = add(baiastm, 365 days); // 1 year\n', '    uint256 lockTime3 = add(baiastm, 548 days); // 18 months\n', '\n', '    uint256 currentRatio = 0;\n', '    if (now >= lockTime1) {\n', '      currentRatio = 20;\n', '    }\n', '    if (now >= lockTime2) {\n', '      currentRatio = 50;  //+30\n', '    }\n', '    if (now >= lockTime3) {\n', '      currentRatio = 100; //+50\n', '    }\n', '    require(currentRatio > 0);\n', '\n', '    uint256 totalReleaseAmt = div(mul(total, currentRatio), 100);\n', '    uint256 grantAmt = sub(totalReleaseAmt, releasedAmt);\n', '    require(grantAmt > 0);\n', '    releasedAmt = add(releasedAmt, grantAmt);\n', '\n', '    uint256 grantAmountForEach = div(grantAmt, beneficiaries.length);\n', '    for (uint i = 0; i < beneficiaries.length; i++) {\n', '        token.safeTransfer(beneficiaries[i], grantAmountForEach);\n', '    }\n', '  }\n', '\n', '  function setBaias(uint256 _baias) public onlyOwner {\n', '    require(_baias != 0x00);\n', '    baiastm = _baias;\n', '  }\n', '\n', '  function setToken(address newToken) public onlyOwner {\n', '    require(newToken != 0x00);\n', '    token = ERC20Basic(newToken);\n', '  }\n', '\n', '  function getBeneficiaryCount() public view returns(uint256) {\n', '    return beneficiaries.length;\n', '  }\n', '\n', '  function setBeneficiary(uint256 _i, address _addr) public onlyOwner {\n', '    require(_i < beneficiaries.length);\n', '    beneficiaries[_i] = _addr;\n', '  }\n', '}']