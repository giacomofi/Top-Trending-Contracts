['pragma solidity ^0.4.18;\n', '\n', 'contract TokenRecipient {\n', '  function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; \n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ExtraHolderContract is TokenRecipient {\n', '  using SafeMath for uint;\n', '\n', '  /// @notice Map of recipients parts of total received tokens\n', '  /// @dev Should be in range of 1 to 10000 (1 is 0.01% and 10000 is 100%)\n', '  mapping(address => uint) public shares;\n', '\n', '  /// @notice Map of total values at moment of latest withdrawal per each recipient\n', '  mapping(address => uint) public totalAtWithdrawal;\n', '\n', '  /// @notice Address of the affilated token\n', '  /// @dev Should be defined at construction and no way to change in future\n', '  address public holdingToken;\n', '\n', '  /// @notice Total amount of received token on smart-contract\n', '  uint public totalReceived;\n', '\n', '  /// @notice Construction method of Extra Holding contract\n', '  /// @dev Arrays of recipients and their share parts should be equal and not empty\n', '  /// @dev Sum of all shares should be exact equal to 10000\n', '  /// @param _holdingToken is address of affilated contract\n', '  /// @param _recipients is array of recipients\n', '  /// @param _partions is array of recipients shares\n', '  function ExtraHolderContract(\n', '    address _holdingToken,\n', '    address[] _recipients,\n', '    uint[] _partions)\n', '  public\n', '  {\n', '    require(_holdingToken != address(0x0));\n', '    require(_recipients.length > 0);\n', '    require(_recipients.length == _partions.length);\n', '\n', '    uint ensureFullfield;\n', '\n', '    for(uint index = 0; index < _recipients.length; index++) {\n', '      // overflow check isn&#39;t required.. I suppose :D\n', '      ensureFullfield = ensureFullfield + _partions[index];\n', '      require(_partions[index] > 0);\n', '      require(_recipients[index] != address(0x0));\n', '\n', '      shares[_recipients[index]] = _partions[index];\n', '    }\n', '\n', '    holdingToken = _holdingToken;\n', '\n', '    // Require to setup exact 100% sum of partions\n', '    require(ensureFullfield == 10000);\n', '  }\n', '\n', '  /// @notice Method what should be called with external contract to receive tokens\n', '  /// @dev Will be call automaticly with a customized transfer method of DefaultToken (based on DefaultToken.sol)\n', '  /// @param _from is address of token sender\n', '  /// @param _value is total amount of sending tokens\n', '  /// @param _token is address of sending token\n', '  /// @param _extraData ...\n', '  function receiveApproval(\n', '    address _from, \n', '    uint256 _value,\n', '    address _token,\n', '    bytes _extraData) public\n', '  {\n', '    _extraData;\n', '    require(_token == holdingToken);\n', '\n', '    // Take tokens of fail with exception\n', '    ERC20(holdingToken).transferFrom(_from, address(this), _value);\n', '    totalReceived = totalReceived.add(_value);\n', '  }\n', '\n', '  /// @notice Method to withdraw shared part of received tokens for providen address\n', '  /// @dev Any address could fire method, but only for known recipient\n', '  /// @param _recipient address of recipient who should receive withdrawed tokens\n', '  function withdraw(\n', '    address _recipient)\n', '  public returns (bool) \n', '  {\n', '    require(shares[_recipient] > 0);\n', '    require(totalAtWithdrawal[_recipient] < totalReceived);\n', '\n', '    uint left = totalReceived.sub(totalAtWithdrawal[_recipient]);\n', '    uint share = left.mul(shares[_recipient]).div(10000);\n', '    totalAtWithdrawal[_recipient] = totalReceived;\n', '    ERC20(holdingToken).transfer(_recipient, share);\n', '    return true;\n', '  }\n', '}\n', '\n', 'contract AltExtraHolderContract is ExtraHolderContract {\n', '  address[] private altRecipients = [\n', '    // Transfer two percent of all ALT tokens to bounty program participants on the day of tokens issue.\n', '    // Final distribution will be done by our partner Bountyhive.io who will transfer coins from\n', '    // the provided wallet to all bounty hunters community.\n', '    address(0xd251D75064DacBC5FcCFca91Cb4721B163a159fc),\n', '    // Transfer thirty eight percent of all ALT tokens for future Network Growth and Team and Advisors remunerations.\n', '    address(0xAd089b3767cf58c7647Db2E8d9C049583bEA045A)\n', '  ];\n', '  uint[] private altPartions = [\n', '    500,\n', '    9500\n', '  ];\n', '\n', '  function AltExtraHolderContract(address _holdingToken)\n', '    ExtraHolderContract(_holdingToken, altRecipients, altPartions)\n', '    public\n', '  {}\n', '}']