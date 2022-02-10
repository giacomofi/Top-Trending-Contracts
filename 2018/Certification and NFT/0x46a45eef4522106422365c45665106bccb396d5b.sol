['pragma solidity 0.4.24;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner,"Sender not authorized");\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract ERC20Interface {\n', '     function totalSupply() public constant returns (uint);\n', '     function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '     function transfer(address to, uint tokens) public returns (bool success);\n', '     function approve(address spender, uint tokens) public returns (bool success);\n', '     function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '     event Transfer(address indexed from, address indexed to, uint tokens);\n', '     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', 'contract DaigouResellerTokenAD is Ownable{\n', '    \n', '  // The token being sold\n', '  ERC20Interface public token;\n', '\n', '  \n', '  mapping(address=>bool) airdroppedTo;\n', '  uint public TOTAL_AIRDROPPED_TOKENS;\n', '  uint public Airdrop_Limit;\n', '  \n', '  /**\n', '   * event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '  constructor(address _wallet, address _tokenAddress) public \n', '  {\n', '    require(_wallet != 0x0);\n', '    require (_tokenAddress != 0x0);\n', '    owner = _wallet;\n', '    token = ERC20Interface(_tokenAddress);\n', '    TOTAL_AIRDROPPED_TOKENS = 0;\n', '    Airdrop_Limit=100000000*10**18;\n', '  }\n', '  \n', '  // fallback function can be used to buy tokens\n', '  function () public payable {\n', '    revert();\n', '  }\n', '\n', '    /**\n', '     * airdrop to token holders\n', '     **/ \n', '    function BulkTransfer(address[] tokenHolders, uint[] amount) public onlyOwner {\n', '        require (TOTAL_AIRDROPPED_TOKENS<=Airdrop_Limit);\n', '        for(uint i = 0; i<tokenHolders.length; i++)\n', '        {\n', '            if (!airdroppedTo[tokenHolders[i]])\n', '            {\n', '                token.transferFrom(owner,tokenHolders[i],amount[i]);\n', '                airdroppedTo[tokenHolders[i]] = true;\n', '                TOTAL_AIRDROPPED_TOKENS += amount[i];\n', '            }\n', '        }\n', '    }\n', '}']
['pragma solidity 0.4.24;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner,"Sender not authorized");\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract ERC20Interface {\n', '     function totalSupply() public constant returns (uint);\n', '     function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '     function transfer(address to, uint tokens) public returns (bool success);\n', '     function approve(address spender, uint tokens) public returns (bool success);\n', '     function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '     event Transfer(address indexed from, address indexed to, uint tokens);\n', '     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', 'contract DaigouResellerTokenAD is Ownable{\n', '    \n', '  // The token being sold\n', '  ERC20Interface public token;\n', '\n', '  \n', '  mapping(address=>bool) airdroppedTo;\n', '  uint public TOTAL_AIRDROPPED_TOKENS;\n', '  uint public Airdrop_Limit;\n', '  \n', '  /**\n', '   * event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '  constructor(address _wallet, address _tokenAddress) public \n', '  {\n', '    require(_wallet != 0x0);\n', '    require (_tokenAddress != 0x0);\n', '    owner = _wallet;\n', '    token = ERC20Interface(_tokenAddress);\n', '    TOTAL_AIRDROPPED_TOKENS = 0;\n', '    Airdrop_Limit=100000000*10**18;\n', '  }\n', '  \n', '  // fallback function can be used to buy tokens\n', '  function () public payable {\n', '    revert();\n', '  }\n', '\n', '    /**\n', '     * airdrop to token holders\n', '     **/ \n', '    function BulkTransfer(address[] tokenHolders, uint[] amount) public onlyOwner {\n', '        require (TOTAL_AIRDROPPED_TOKENS<=Airdrop_Limit);\n', '        for(uint i = 0; i<tokenHolders.length; i++)\n', '        {\n', '            if (!airdroppedTo[tokenHolders[i]])\n', '            {\n', '                token.transferFrom(owner,tokenHolders[i],amount[i]);\n', '                airdroppedTo[tokenHolders[i]] = true;\n', '                TOTAL_AIRDROPPED_TOKENS += amount[i];\n', '            }\n', '        }\n', '    }\n', '}']