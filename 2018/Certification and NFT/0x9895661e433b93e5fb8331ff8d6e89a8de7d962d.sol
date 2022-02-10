['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title Helps contracts guard agains reentrancy attacks.\n', ' * @author Remco Bloemen <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="0d7f68606e624d3f">[email&#160;protected]</a>π.com>\n', ' * @notice If you mark a function `nonReentrant`, you should also\n', ' * mark it `external`.\n', ' */\n', 'contract ReentrancyGuard {\n', '\n', '  /**\n', '   * @dev We use a single lock for the whole contract.\n', '   */\n', '  bool private reentrancyLock = false;\n', '\n', '  /**\n', '   * @dev Prevents a contract from calling itself, directly or indirectly.\n', '   * @notice If you mark a function `nonReentrant`, you should also\n', '   * mark it `external`. Calling one nonReentrant function from\n', '   * another is not supported. Instead, you can implement a\n', '   * `private` function doing the actual work, and a `external`\n', '   * wrapper marked as `nonReentrant`.\n', '   */\n', '  modifier nonReentrant() {\n', '    require(!reentrancyLock);\n', '    reentrancyLock = true;\n', '    _;\n', '    reentrancyLock = false;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    // Gas optimization: this is cheaper than asserting &#39;a&#39; not being zero, but the\n', '    // benefit is lost if &#39;b&#39; is also tested.\n', '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', 'interface ERC20 {\n', '    function totalSupply() external view returns (uint supply);\n', '    function balanceOf(address _owner) external view returns (uint balance);\n', '    function transfer(address _to, uint _value) external returns (bool success);\n', '    function transferFrom(address _from, address _to, uint _value) external returns (bool success);\n', '    function approve(address _spender, uint _value) external returns (bool success);\n', '    function allowance(address _owner, address _spender) external view returns (uint remaining);\n', '    function decimals() external view returns(uint digits);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', '\n', '/*\n', '* There are 4 entities in this contract - \n', '#1 `company` - This is the company which is going to place a bounty of tokens\n', '#2 `referrer` - This is the referrer who refers a candidate that gets a job finally\n', '#3 `candidate` - This is the candidate who gets a job finally\n', '#4 `owner` - Indorse as a company will be the owner of this contract\n', '*\n', '*/\n', '\n', 'contract JobsBounty is Ownable, ReentrancyGuard {\n', '    using SafeMath for uint256;\n', '    string public companyName; //Name of the company who is putting the bounty\n', '    string public jobPost; //Link to the job post for this Smart Contract\n', '    uint public endDate; //Unix timestamp of the end date of this contract when the bounty can be released\n', '    \n', '    // On Rinkeby\n', '    // address public INDToken = 0x656c7da9501bB3e4A5a544546230D74c154A42eb;\n', '    // On Mainnet\n', '    address public INDToken = 0xf8e386eda857484f5a12e4b5daa9984e06e73705;\n', '    \n', '    constructor(string _companyName,\n', '                string _jobPost,\n', '                uint _endDate\n', '                ) public{\n', '        companyName = _companyName;\n', '        jobPost = _jobPost ;\n', '        endDate = _endDate;\n', '    }\n', '    \n', '    //Helper function, not really needed, but good to have for the sake of posterity\n', '    function ownBalance() public view returns(uint256) {\n', '        return ERC20(INDToken).balanceOf(this);\n', '    }\n', '    \n', '    function payOutBounty(address _referrerAddress, address _candidateAddress) public onlyOwner nonReentrant returns(bool){\n', '        uint256 individualAmounts = (ERC20(INDToken).balanceOf(this) / 100) * 50;\n', '        \n', '        assert(block.timestamp >= endDate);\n', '        // Tranferring to the candidate first\n', '        assert(ERC20(INDToken).transfer(_candidateAddress, individualAmounts));\n', '        assert(ERC20(INDToken).transfer(_referrerAddress, individualAmounts));\n', '        return true;    \n', '    }\n', '    \n', '    //This function can be used in 2 instances - \n', '    // 1st one if to withdraw tokens that are accidentally send to this Contract\n', '    // 2nd is to actually withdraw the tokens and return it to the company in case they don&#39;t find a candidate\n', '    function withdrawERC20Token(address anyToken) public onlyOwner nonReentrant returns(bool){\n', '        assert(block.timestamp >= endDate);\n', '        assert(ERC20(anyToken).transfer(owner, ERC20(anyToken).balanceOf(this)));        \n', '        return true;\n', '    }\n', '    \n', '    //ETH cannot get locked in this contract. If it does, this can be used to withdraw\n', '    //the locked ether.\n', '    function withdrawEther() public nonReentrant returns(bool){\n', '        if(address(this).balance > 0){\n', '            owner.transfer(address(this).balance);\n', '        }        \n', '        return true;\n', '    }\n', '}']