['pragma solidity ^0.4.18;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract BeatOrgTokenPostSale is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    address public wallet;\n', '\n', '    uint256 public endTime;\n', '    bool public finalized;\n', '\n', '    uint256 public weiRaised;\n', '    mapping(address => uint256) public purchases;\n', '\n', '    event Purchase(address indexed purchaser, address indexed beneficiary, uint256 weiAmount);\n', '\n', '    function BeatOrgTokenPostSale(address _wallet) public {\n', '        require(_wallet != address(0));\n', '        wallet = _wallet;\n', '\n', '        // 2018-07-15T23:59:59+02:00\n', '        endTime = 1531691999;\n', '        finalized = false;\n', '    }\n', '\n', '    function() payable public {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    function buyTokens(address beneficiary) payable public {\n', '        require(beneficiary != address(0));\n', '        require(msg.value != 0);\n', '        require(validPurchase());\n', '\n', '        uint256 weiAmount = msg.value;\n', '\n', '        purchases[beneficiary] += weiAmount;\n', '        weiRaised += weiAmount;\n', '\n', '        Purchase(msg.sender, beneficiary, weiAmount);\n', '\n', '        wallet.transfer(weiAmount);\n', '    }\n', '\n', '    function finalize() onlyOwner public {\n', '        endTime = now;\n', '        finalized = true;\n', '    }\n', '\n', '    function validPurchase() internal view returns (bool) {\n', '        return (now <= endTime) && (finalized == false);\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.18;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract BeatOrgTokenPostSale is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    address public wallet;\n', '\n', '    uint256 public endTime;\n', '    bool public finalized;\n', '\n', '    uint256 public weiRaised;\n', '    mapping(address => uint256) public purchases;\n', '\n', '    event Purchase(address indexed purchaser, address indexed beneficiary, uint256 weiAmount);\n', '\n', '    function BeatOrgTokenPostSale(address _wallet) public {\n', '        require(_wallet != address(0));\n', '        wallet = _wallet;\n', '\n', '        // 2018-07-15T23:59:59+02:00\n', '        endTime = 1531691999;\n', '        finalized = false;\n', '    }\n', '\n', '    function() payable public {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    function buyTokens(address beneficiary) payable public {\n', '        require(beneficiary != address(0));\n', '        require(msg.value != 0);\n', '        require(validPurchase());\n', '\n', '        uint256 weiAmount = msg.value;\n', '\n', '        purchases[beneficiary] += weiAmount;\n', '        weiRaised += weiAmount;\n', '\n', '        Purchase(msg.sender, beneficiary, weiAmount);\n', '\n', '        wallet.transfer(weiAmount);\n', '    }\n', '\n', '    function finalize() onlyOwner public {\n', '        endTime = now;\n', '        finalized = true;\n', '    }\n', '\n', '    function validPurchase() internal view returns (bool) {\n', '        return (now <= endTime) && (finalized == false);\n', '    }\n', '\n', '}']