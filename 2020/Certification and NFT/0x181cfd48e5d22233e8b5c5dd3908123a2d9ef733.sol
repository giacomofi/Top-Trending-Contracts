['pragma solidity 0.6.8;\n', '\n', 'library SafeMath {\n', '  /**\n', '  * @dev Multiplies two unsigned integers, reverts on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '        return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // Solidity only automatically asserts when dividing by 0\n', '    require(b > 0);\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two unsigned integers, reverts on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', 'interface ERC20 {\n', '  function balanceOf(address who) external view returns (uint256);\n', '  function transfer(address to, uint value) external returns (bool success);\n', '  function transferFrom(address from, address to, uint value) external returns (bool success);\n', '}\n', '\n', 'interface CuraAnnonaes {\n', '  function getDailyReward() external view returns (uint256);\n', '  function getNumberOfVaults() external view returns (uint256);\n', '  function getUserBalanceInVault(string calldata vault, address user) external view returns (uint256);\n', '  function stake(string calldata, address receiver, uint256 amount, address _vault) external returns (bool);\n', '  function unstake(string calldata vault, address receiver, address _vault) external;\n', '  function updateVaultData(string calldata vault, address who, address user, uint value) external;\n', '}\n', '\n', '// https://en.wikipedia.org/wiki/Cura_Annonae\n', 'contract YFMSVault {\n', '  using SafeMath for uint256;\n', '\n', '  // variables.\n', '  address public owner;\n', '  address[] public stakers; // tracks all addresses in vault.\n', '  uint256 public burnTotal = 0;\n', '  CuraAnnonaes public CuraAnnonae;\n', '  ERC20 public YFMSToken;\n', '  \n', '  constructor(address _cura, address _token) public {\n', '    owner = msg.sender;\n', '    CuraAnnonae = CuraAnnonaes(_cura);\n', '    YFMSToken = ERC20(_token);\n', '  }\n', '\n', '  // balance of a user in the vault.\n', '  function getUserBalance(address _from) public view returns (uint256) {\n', '    return CuraAnnonae.getUserBalanceInVault("YFMS", _from);\n', '  }\n', '\n', '  // returns all users currently staking in this vault.\n', '  function getStakers() public view returns (address[] memory) {\n', '    return stakers; \n', '  }\n', '\n', '  function getUnstakingFee(address _user) public view returns (uint256) {\n', '    uint256 _balance = getUserBalance(_user);\n', '    return _balance / 10000 * 250;\n', '  }\n', '\n', '  function cleanStakersArray(address user) internal {\n', '    uint256 index;\n', '    // search the array for the user.\n', '    for (uint i=0; i < stakers.length; i++) {\n', '      if (stakers[i] == user)\n', '        index = i;\n', '      break;\n', '    }\n', '    // swap the last user in the array for the current unstaked user.\n', '    stakers[index] = stakers[stakers.length - 1];\n', '    // remove the last element (empty)\n', '    stakers.pop();\n', '  }\n', '\n', '  function stakeYFMS(uint256 _amount, address _from) public {\n', '    // add user to stakers array if not currently present.\n', '    require(msg.sender == _from);\n', '    require(_amount >= 500000000000000000);\n', '    require(_amount <= YFMSToken.balanceOf(_from));\n', '    if (getUserBalance(_from) == 0)\n', '      stakers.push(_from);\n', '    YFMSToken.transferFrom(_from, address(this), _amount);\n', '    require(CuraAnnonae.stake("YFMS", _from, _amount, address(this)));\n', '  }\n', '\n', '  function unstakeYFMS(address _to) public {\n', '    uint256 _unstakingFee = getUnstakingFee(_to);\n', '    uint256 _amount = getUserBalance(_to).sub(_unstakingFee);\n', '    // ensure data integrity.\n', '    require(_amount > 0);\n', '    require(msg.sender == _to);\n', '    // first transfer funds back to the user then burn the unstaking fee.\n', '    YFMSToken.transfer(_to, _amount);\n', '    YFMSToken.transfer(address(0), _unstakingFee);\n', '    // add to burn total.\n', '    burnTotal = burnTotal.add(_unstakingFee); \n', '    // unstake.\n', '    CuraAnnonae.unstake("YFMS", _to, address(this));\n', '    // remove user from array.\n', '    cleanStakersArray(_to);\n', '  }\n', '\n', '  function ratioMath(uint256 _numerator, uint256 _denominator) internal pure returns (uint256) {\n', '    uint256 numerator = _numerator * 10 ** 18; // precision to 18 decimals.\n', '    uint256 quotient = (numerator / _denominator).add(5).div(10);\n', '    return quotient;\n', '  }\n', '\n', '  // daily call to distribute vault rewards to users who have staked.\n', '  function distributeVaultRewards () public {\n', '    require(msg.sender == owner);\n', '    uint256 _reward = CuraAnnonae.getDailyReward();\n', '    uint256 _vaults = CuraAnnonae.getNumberOfVaults();\n', '    uint256 _vaultReward = _reward.div(_vaults);\n', '    // remove daily reward from address(this) total.\n', '    uint256 _pool = YFMSToken.balanceOf(address(this)).sub(_vaultReward);\n', '    uint256 _userBalance;\n', '    uint256 _earned;\n', '    // iterate through stakers array and distribute rewards based on % staked.\n', '    for (uint i = 0; i < stakers.length; i++) {\n', '      _userBalance = getUserBalance(stakers[i]);\n', '      if (_userBalance > 0) {\n', '        _earned = ratioMath(_userBalance, _pool).mul(_vaultReward / 100000000000000000);\n', '        // update the vault data.\n', '        CuraAnnonae.updateVaultData("YFMS", address(this), stakers[i], _earned);\n', '      }\n', '    }\n', '  }\n', '}']