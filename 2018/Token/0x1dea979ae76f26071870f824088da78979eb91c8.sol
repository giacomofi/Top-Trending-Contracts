['pragma solidity ^0.4.21;\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() external view returns (uint256);\n', '  function balanceOf(address who) external view returns (uint256);\n', '  function transfer(address to, uint256 value) external returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address holder, address spender) external view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '  function approve(address spender, uint256 value) external returns (bool);\n', '  event Approval(address indexed holder, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // require(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // require(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract SpindleToken is ERC20, Ownable {\n', '\n', '    using SafeMath for uint256;\n', '\n', "    string public constant name = 'SPINDLE';\n", "    string public constant symbol = 'SPD';\n", '    uint8 public constant decimals = 18;\n', '\n', '    uint256 constant TOTAL_SPD = 10000000000;\n', '    uint256 constant TOTAL_SUPPLY = TOTAL_SPD * (uint256(10) ** decimals);\n', '\n', '    uint64 constant ICO_START_TIME = 1526083200; // 2018-05-12\n', '    uint64 constant RELEASE_B = ICO_START_TIME + 30 days;\n', '    uint64 constant RELEASE_C = ICO_START_TIME + 60 days;\n', '    uint64 constant RELEASE_D = ICO_START_TIME + 90 days;\n', '    uint64 constant RELEASE_E = ICO_START_TIME + 180 days;\n', '    uint64 constant RELEASE_F = ICO_START_TIME + 270 days;\n', '    uint64[] RELEASE = new uint64[](6);\n', '\n', '    mapping(address => uint256[6]) balances;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '\n', '    /**\n', '     * @dev Constructor that gives msg.sender all of existing tokens.\n', '     */\n', '    function SpindleToken() public {\n', '        RELEASE[0] = ICO_START_TIME;\n', '        RELEASE[1] = RELEASE_B;\n', '        RELEASE[2] = RELEASE_C;\n', '        RELEASE[3] = RELEASE_D;\n', '        RELEASE[4] = RELEASE_E;\n', '        RELEASE[5] = RELEASE_F;\n', '\n', '        balances[msg.sender][0] = TOTAL_SUPPLY;\n', '        emit Transfer(0x0, msg.sender, TOTAL_SUPPLY);\n', '    }\n', '\n', '    /**\n', '     * @dev total number of tokens in existence\n', '     */\n', '    function totalSupply() external view returns (uint256) {\n', '        return TOTAL_SUPPLY;\n', '    }\n', '\n', '    /**\n', '     * @dev transfer token for a specified address\n', '     * @param _to The address to transfer to.\n', '     * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) external returns (bool) {\n', '        require(_to != address(0));\n', '        require(_to != address(this));\n', '        _updateLockUpAmountOf(msg.sender);\n', '\n', '        // SafeMath.sub will revert if there is not enough balance.\n', '        balances[msg.sender][0] = balances[msg.sender][0].sub(_value);\n', '        balances[_to][0] = balances[_to][0].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the payable balance of the specified address.\n', '     * @param _holder The address to query the the balance of.\n', '     * @return An uint256 representing the payable amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _holder) external view returns (uint256) {\n', '        uint256[6] memory arr = lockUpAmountOf(_holder);\n', '        return arr[0];\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the lockUpAmount tuple of the specified address.\n', '     * @param _holder address The address to query the the balance of.\n', '     * @return An LockUpAmount representing the amount owned by the passed address.\n', '    */\n', '    function lockUpAmountOf(address _holder) public view returns (\n', '        uint256[6]\n', '    ) {\n', '        uint256[6] memory arr;\n', '        arr[0] = balances[_holder][0];\n', '        for (uint i = 1; i < RELEASE.length; i++) {\n', '            arr[i] = balances[_holder][i];\n', '            if(now >= RELEASE[i]){\n', '                arr[0] = arr[0].add(balances[_holder][i]);\n', '                arr[i] = 0;\n', '            }\n', '            else\n', '            {\n', '                arr[i] = balances[_holder][i];\n', '            }\n', '        }\n', '        return arr;\n', '    }\n', '\n', '    /**\n', '     * @dev update the lockUpAmount of _address.\n', '     * @param _address address The address updated the balances of.\n', '     */\n', '    function _updateLockUpAmountOf(address _address) internal {\n', '        uint256[6] memory arr = lockUpAmountOf(_address);\n', '\n', '        for(uint8 i = 0;i < arr.length; i++){\n', '            balances[_address][i] = arr[i];\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev gets the strings of lockUpAmount of _address.\n', '     * @param _address address The address gets the string of lockUpAmount of.\n', '     */\n', '    function lockUpAmountStrOf(address _address) external view returns (\n', '        address Address,\n', '        string a,\n', '        string b,\n', '        string c,\n', '        string d,\n', '        string e,\n', '        string f\n', '    ) {\n', '        address __address = _address;\n', '        if(__address == address(0)) __address = msg.sender;\n', '\n', '        uint256[6] memory arr = lockUpAmountOf(__address);\n', '\n', '        return (\n', '            __address,\n', '            _uintToSPDStr(arr[0]),\n', '            _uintToSPDStr(arr[1]),\n', '            _uintToSPDStr(arr[2]),\n', '            _uintToSPDStr(arr[3]),\n', '            _uintToSPDStr(arr[4]),\n', '            _uintToSPDStr(arr[5])\n', '        );\n', '    }\n', '\n', '    /**\n', '     * @dev gets the SPD_strings of a token amount.\n', '     * @param _amount The value of a token amount.\n', '     */\n', '    function _uintToSPDStr(uint256 _amount) internal pure returns (string) {\n', '        uint8 __tindex;\n', '        uint8 __sindex;\n', '        uint8 __left;\n', '        uint8 __right;\n', "        bytes memory __t = new bytes(30);  // '10000000000.000000000000000000'.length is 30 (max input)\n", '\n', '        // set all bytes\n', '        for(__tindex = 29; ; __tindex--){  // last_index:29 to first_index:0\n', '            if(__tindex == 11){            // dot index\n', "                __t[__tindex] = byte(46);  // byte of '.' is 46\n", '                continue;\n', '            }\n', "            __t[__tindex] = byte(48 + _amount%10);  // byte of '0' is 48\n", '            _amount = _amount.div(10);\n', '            if(__tindex == 0) break;\n', '        }\n', '\n', '        // calc the str region\n', "        for(__left = 0; __left < 10; __left++) {     // find the first index of non-zero byte.  return at least '0.xxxxx'\n", "            if(__t[__left]  != byte(48)) break;      // byte of '0' is 48\n", '        }\n', "        for(__right = 29; __right > 12; __right--){  // find the  last index of non-zero byte.  return at least 'xxxxx.0'\n", "            if(__t[__right] != byte(48)) break;      // byte of '0' is 48\n", '        }\n', '\n', "        bytes memory __s = new bytes(__right - __left + 1 + 4); // allocatte __s[left..right] + ' SPD'\n", '\n', '        // set and return\n', '        __sindex = 0;\n', '        for(__tindex = __left; __tindex <= __right; __tindex++){\n', '            __s[__sindex] = __t[__tindex];\n', '            __sindex++;\n', '        }\n', '\n', "        __s[__sindex++] = byte(32);  // byte of ' ' is 32\n", "        __s[__sindex++] = byte(83);  // byte of 'S' is 83\n", "        __s[__sindex++] = byte(80);  // byte of 'P' is 80\n", "        __s[__sindex++] = byte(68);  // byte of 'D' is 68\n", '\n', '        return string(__s);\n', '    }\n', '\n', '    /**\n', '     * @dev Distribute tokens from owner address to another\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _a uint256 the amount of A-type-tokens to be transferred\n', '     * ...\n', '     * @param _f uint256 the amount of F-type-tokens to be transferred\n', '     */\n', '    function distribute(address _to, uint256 _a, uint256 _b, uint256 _c, uint256 _d, uint256 _e, uint256 _f) onlyOwner external returns (bool) {\n', '        require(_to != address(0));\n', '        _updateLockUpAmountOf(msg.sender);\n', '\n', '        uint256 __total = 0;\n', '        __total = __total.add(_a);\n', '        __total = __total.add(_b);\n', '        __total = __total.add(_c);\n', '        __total = __total.add(_d);\n', '        __total = __total.add(_e);\n', '        __total = __total.add(_f);\n', '\n', '        balances[msg.sender][0] = balances[msg.sender][0].sub(__total);\n', '\n', '        balances[_to][0] = balances[_to][0].add(_a);\n', '        balances[_to][1] = balances[_to][1].add(_b);\n', '        balances[_to][2] = balances[_to][2].add(_c);\n', '        balances[_to][3] = balances[_to][3].add(_d);\n', '        balances[_to][4] = balances[_to][4].add(_e);\n', '        balances[_to][5] = balances[_to][5].add(_f);\n', '\n', '        emit Transfer(msg.sender, _to, __total);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {\n', '        require(_to != address(0));\n', '        require(_to != address(this));\n', '        _updateLockUpAmountOf(_from);\n', '\n', '        balances[_from][0] = balances[_from][0].sub(_value);\n', '        balances[_to][0] = balances[_to][0].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     *\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint256 _value) external returns (bool) {\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _holder address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '    */\n', '    function allowance(address _holder, address _spender) external view returns (uint256) {\n', '        return allowed[_holder][_spender];\n', '    }\n', '}']