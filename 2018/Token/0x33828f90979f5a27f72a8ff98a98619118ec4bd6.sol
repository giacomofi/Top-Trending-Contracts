['pragma solidity 0.4.21;\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '  function safeTransfer(ERC20Basic token, address to, uint256 value) internal {\n', '    assert(token.transfer(to, value));\n', '  }\n', '\n', '  function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {\n', '    assert(token.transferFrom(from, to, value));\n', '  }\n', '\n', '  function safeApprove(ERC20 token, address spender, uint256 value) internal {\n', '    assert(token.approve(spender, value));\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract Whitelisting is Ownable {\n', '    mapping(address => bool) public isInvestorApproved;\n', '\n', '    event Approved(address indexed investor);\n', '    event Disapproved(address indexed investor);\n', '\n', '    function approveInvestor(address toApprove) public onlyOwner {\n', '        isInvestorApproved[toApprove] = true;\n', '        emit Approved(toApprove);\n', '    }\n', '\n', '    function approveInvestorsInBulk(address[] toApprove) public onlyOwner {\n', '        for (uint i=0; i<toApprove.length; i++) {\n', '            isInvestorApproved[toApprove[i]] = true;\n', '            emit Approved(toApprove[i]);\n', '        }\n', '    }\n', '\n', '    function disapproveInvestor(address toDisapprove) public onlyOwner {\n', '        delete isInvestorApproved[toDisapprove];\n', '        emit Disapproved(toDisapprove);\n', '    }\n', '\n', '    function disapproveInvestorsInBulk(address[] toDisapprove) public onlyOwner {\n', '        for (uint i=0; i<toDisapprove.length; i++) {\n', '            delete isInvestorApproved[toDisapprove[i]];\n', '            emit Disapproved(toDisapprove[i]);\n', '        }\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title TokenVesting\n', ' * @dev TokenVesting is a token holder contract that will allow a\n', ' * beneficiary to extract the tokens after a given release time\n', ' */\n', 'contract TokenVesting is Ownable {\n', '    using SafeERC20 for ERC20Basic;\n', '    using SafeMath for uint256;\n', '\n', '    // ERC20 basic token contract being held\n', '    ERC20Basic public token;\n', '    // whitelisting contract being held\n', '    Whitelisting public whitelisting;\n', '\n', '    struct VestingObj {\n', '        uint256 token;\n', '        uint256 releaseTime;\n', '    }\n', '\n', '    mapping (address  => VestingObj[]) public vestingObj;\n', '\n', '    uint256 public totalTokenVested;\n', '\n', '    event AddVesting ( address indexed _beneficiary, uint256 token, uint256 _vestingTime);\n', '    event Release ( address indexed _beneficiary, uint256 token, uint256 _releaseTime);\n', '\n', '    modifier checkZeroAddress(address _add) {\n', '        require(_add != address(0));\n', '        _;\n', '    }\n', '\n', '    function TokenVesting(ERC20Basic _token, Whitelisting _whitelisting)\n', '        public\n', '        checkZeroAddress(_token)\n', '        checkZeroAddress(_whitelisting)\n', '    {\n', '        token = _token;\n', '        whitelisting = _whitelisting;\n', '    }\n', '\n', '    function addVesting( address[] _beneficiary, uint256[] _token, uint256[] _vestingTime) \n', '        external \n', '        onlyOwner\n', '    {\n', '        require((_beneficiary.length == _token.length) && (_beneficiary.length == _vestingTime.length));\n', '        \n', '        for (uint i = 0; i < _beneficiary.length; i++) {\n', '            require(_vestingTime[i] > now);\n', '            require(checkZeroValue(_token[i]));\n', '            require(uint256(getBalance()) >= totalTokenVested.add(_token[i]));\n', '            vestingObj[_beneficiary[i]].push(VestingObj({\n', '                token : _token[i],\n', '                releaseTime : _vestingTime[i]\n', '            }));\n', '            totalTokenVested = totalTokenVested.add(_token[i]);\n', '            emit AddVesting(_beneficiary[i], _token[i], _vestingTime[i]);\n', '        }\n', '    }\n', '\n', '    /**\n', '   * @notice Transfers tokens held by timelock to beneficiary.\n', '   */\n', '    function claim() external {\n', '        require(whitelisting.isInvestorApproved(msg.sender));\n', '        uint256 transferTokenCount = 0;\n', '        for (uint i = 0; i < vestingObj[msg.sender].length; i++) {\n', '            if (now >= vestingObj[msg.sender][i].releaseTime) {\n', '                transferTokenCount = transferTokenCount.add(vestingObj[msg.sender][i].token);\n', '                delete vestingObj[msg.sender][i];\n', '            }\n', '        }\n', '        require(transferTokenCount > 0);\n', '        token.safeTransfer(msg.sender, transferTokenCount);\n', '        emit Release(msg.sender, transferTokenCount, now);\n', '    }\n', '\n', '    function getBalance() public view returns (uint256) {\n', '        return token.balanceOf(address(this));\n', '    }\n', '    \n', '    function checkZeroValue(uint256 value) internal returns(bool){\n', '        return value > 0;\n', '    }\n', '}']
['pragma solidity 0.4.21;\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '  function safeTransfer(ERC20Basic token, address to, uint256 value) internal {\n', '    assert(token.transfer(to, value));\n', '  }\n', '\n', '  function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {\n', '    assert(token.transferFrom(from, to, value));\n', '  }\n', '\n', '  function safeApprove(ERC20 token, address spender, uint256 value) internal {\n', '    assert(token.approve(spender, value));\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract Whitelisting is Ownable {\n', '    mapping(address => bool) public isInvestorApproved;\n', '\n', '    event Approved(address indexed investor);\n', '    event Disapproved(address indexed investor);\n', '\n', '    function approveInvestor(address toApprove) public onlyOwner {\n', '        isInvestorApproved[toApprove] = true;\n', '        emit Approved(toApprove);\n', '    }\n', '\n', '    function approveInvestorsInBulk(address[] toApprove) public onlyOwner {\n', '        for (uint i=0; i<toApprove.length; i++) {\n', '            isInvestorApproved[toApprove[i]] = true;\n', '            emit Approved(toApprove[i]);\n', '        }\n', '    }\n', '\n', '    function disapproveInvestor(address toDisapprove) public onlyOwner {\n', '        delete isInvestorApproved[toDisapprove];\n', '        emit Disapproved(toDisapprove);\n', '    }\n', '\n', '    function disapproveInvestorsInBulk(address[] toDisapprove) public onlyOwner {\n', '        for (uint i=0; i<toDisapprove.length; i++) {\n', '            delete isInvestorApproved[toDisapprove[i]];\n', '            emit Disapproved(toDisapprove[i]);\n', '        }\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title TokenVesting\n', ' * @dev TokenVesting is a token holder contract that will allow a\n', ' * beneficiary to extract the tokens after a given release time\n', ' */\n', 'contract TokenVesting is Ownable {\n', '    using SafeERC20 for ERC20Basic;\n', '    using SafeMath for uint256;\n', '\n', '    // ERC20 basic token contract being held\n', '    ERC20Basic public token;\n', '    // whitelisting contract being held\n', '    Whitelisting public whitelisting;\n', '\n', '    struct VestingObj {\n', '        uint256 token;\n', '        uint256 releaseTime;\n', '    }\n', '\n', '    mapping (address  => VestingObj[]) public vestingObj;\n', '\n', '    uint256 public totalTokenVested;\n', '\n', '    event AddVesting ( address indexed _beneficiary, uint256 token, uint256 _vestingTime);\n', '    event Release ( address indexed _beneficiary, uint256 token, uint256 _releaseTime);\n', '\n', '    modifier checkZeroAddress(address _add) {\n', '        require(_add != address(0));\n', '        _;\n', '    }\n', '\n', '    function TokenVesting(ERC20Basic _token, Whitelisting _whitelisting)\n', '        public\n', '        checkZeroAddress(_token)\n', '        checkZeroAddress(_whitelisting)\n', '    {\n', '        token = _token;\n', '        whitelisting = _whitelisting;\n', '    }\n', '\n', '    function addVesting( address[] _beneficiary, uint256[] _token, uint256[] _vestingTime) \n', '        external \n', '        onlyOwner\n', '    {\n', '        require((_beneficiary.length == _token.length) && (_beneficiary.length == _vestingTime.length));\n', '        \n', '        for (uint i = 0; i < _beneficiary.length; i++) {\n', '            require(_vestingTime[i] > now);\n', '            require(checkZeroValue(_token[i]));\n', '            require(uint256(getBalance()) >= totalTokenVested.add(_token[i]));\n', '            vestingObj[_beneficiary[i]].push(VestingObj({\n', '                token : _token[i],\n', '                releaseTime : _vestingTime[i]\n', '            }));\n', '            totalTokenVested = totalTokenVested.add(_token[i]);\n', '            emit AddVesting(_beneficiary[i], _token[i], _vestingTime[i]);\n', '        }\n', '    }\n', '\n', '    /**\n', '   * @notice Transfers tokens held by timelock to beneficiary.\n', '   */\n', '    function claim() external {\n', '        require(whitelisting.isInvestorApproved(msg.sender));\n', '        uint256 transferTokenCount = 0;\n', '        for (uint i = 0; i < vestingObj[msg.sender].length; i++) {\n', '            if (now >= vestingObj[msg.sender][i].releaseTime) {\n', '                transferTokenCount = transferTokenCount.add(vestingObj[msg.sender][i].token);\n', '                delete vestingObj[msg.sender][i];\n', '            }\n', '        }\n', '        require(transferTokenCount > 0);\n', '        token.safeTransfer(msg.sender, transferTokenCount);\n', '        emit Release(msg.sender, transferTokenCount, now);\n', '    }\n', '\n', '    function getBalance() public view returns (uint256) {\n', '        return token.balanceOf(address(this));\n', '    }\n', '    \n', '    function checkZeroValue(uint256 value) internal returns(bool){\n', '        return value > 0;\n', '    }\n', '}']
