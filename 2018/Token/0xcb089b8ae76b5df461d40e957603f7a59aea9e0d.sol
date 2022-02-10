['pragma solidity 0.5.0;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '    /**\n', '    * @dev Multiplies two numbers, reverts on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, reverts on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '    * reverts when dividing by zero.\n', '    */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address who) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md\n', ' * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract ERC20 is IERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) internal _balances;\n', '\n', '    mapping (address => mapping (address => uint256)) private _allowed;\n', '\n', '    uint256 internal _totalSupply;\n', '\n', '    /**\n', '    * @dev Total number of tokens in existence\n', '    */\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param owner The address to query the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address owner) public view returns (uint256) {\n', '        return _balances[owner];\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param owner address The address which owns the funds.\n', '     * @param spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address owner, address spender) public view returns (uint256) {\n', '        return _allowed[owner][spender];\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer token for a specified address\n', '    * @param to The address to transfer to.\n', '    * @param value The amount to be transferred.\n', '    */\n', '    function transfer(address to, uint256 value) public returns (bool) {\n', '        _transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param spender The address which will spend the funds.\n', '     * @param value The amount of tokens to be spent.\n', '     */\n', '    function approve(address spender, uint256 value) public returns (bool) {\n', '        require(spender != address(0));\n', '\n', '        _allowed[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param from address The address which you want to send tokens from\n', '     * @param to address The address which you want to transfer to\n', '     * @param value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', '        _transfer(from, to, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     * approve should be called when allowed_[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param spender The address which will spend the funds.\n', '     * @param addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n', '        require(spender != address(0));\n', '\n', '        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);\n', '        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     * approve should be called when allowed_[_spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param spender The address which will spend the funds.\n', '     * @param subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n', '        require(spender != address(0));\n', '\n', '        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);\n', '        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer token for a specified addresses\n', '    * @param from The address to transfer from.\n', '    * @param to The address to transfer to.\n', '    * @param value The amount to be transferred.\n', '    */\n', '    function _transfer(address from, address to, uint256 value) internal {\n', '        require(to != address(0));\n', '\n', '        _balances[from] = _balances[from].sub(value);\n', '        _balances[to] = _balances[to].add(value);\n', '        emit Transfer(from, to, value);\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '    * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '    * account.\n', '    */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '    _;\n', '    }\n', '\n', '}\n', '\n', 'contract Claimable is Ownable {\n', '    address public pendingOwner;\n', '\n', '    /**\n', '     * @dev Modifier throws if called by any account other than the pendingOwner.\n', '     */\n', '    modifier onlyPendingOwner() {\n', '        require(msg.sender == pendingOwner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to set the pendingOwner address.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        pendingOwner = newOwner;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the pendingOwner address to finalize the transfer.\n', '     */\n', '    function claimOwnership() onlyPendingOwner public {\n', '        emit OwnershipTransferred(owner, pendingOwner);\n', '        owner = pendingOwner;\n', '        pendingOwner = address(0);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Arroundtoken\n', ' * @dev The Arroundtoken contract is ERC20-compatible token processing contract\n', ' * with additional  features like multiTransfer and reclaimTokens\n', ' *\n', ' */\n', 'contract Arroundtoken is ERC20, Claimable {\n', '    using SafeMath for uint256;\n', '\n', '    uint64 public constant TDE_FINISH = 1542326400;//!!!!Check before deploy\n', '    // 1542326400  GMT: 16 November 2018 г., 00:00:00\n', '    // 1542326399  GMT: 15 November 2018 г., 23:59:59\n', '\n', '\n', '    //////////////////////\n', '    // State var       ///\n', '    //////////////////////\n', '    string  public name;\n', '    string  public symbol;\n', '    uint8   public decimals;\n', '    address public accTDE;\n', '    address public accFoundCDF;\n', '    address public accFoundNDF1;\n', '    address public accFoundNDF2;\n', '    address public accFoundNDF3;\n', '    address public accTeam;\n', '    address public accBounty;\n', '  \n', '    // Implementation of frozen funds\n', '    mapping(address => uint64) public frozenAccounts;\n', '\n', '    //////////////\n', '    // EVENTS    //\n', '    ///////////////\n', '    event NewFreeze(address _acc, uint64 _timestamp);\n', '    event BatchDistrib(uint8 cnt, uint256 batchAmount);\n', '    \n', '    /**\n', '     * @param _accTDE - main address for token distribution\n', '     * @param _accFoundCDF  - address for CDF Found tokens (WP)\n', '     * @param _accFoundNDF1 - address for NDF Found tokens (WP)\n', '     * @param _accFoundNDF2 - address for NDF Found tokens (WP)\n', '     * @param _accFoundNDF3 - address for NDF Found tokens (WP)\n', '     * @param _accTeam - address for team tokens, will frozzen by one year\n', '     * @param _accBounty - address for bounty tokens \n', '     * @param _initialSupply - subj\n', '     */  \n', '    constructor (\n', '        address _accTDE, \n', '        address _accFoundCDF,\n', '        address _accFoundNDF1,\n', '        address _accFoundNDF2,\n', '        address _accFoundNDF3,\n', '        address _accTeam,\n', '        address _accBounty, \n', '        uint256 _initialSupply\n', '    )\n', '    public \n', '    {\n', '        require(_accTDE       != address(0));\n', '        require(_accFoundCDF  != address(0));\n', '        require(_accFoundNDF1 != address(0));\n', '        require(_accFoundNDF2 != address(0));\n', '        require(_accFoundNDF3 != address(0));\n', '        require(_accTeam      != address(0));\n', '        require(_accBounty    != address(0));\n', '        require(_initialSupply > 0);\n', '        name           = "Arround";\n', '        symbol         = "ARR";\n', '        decimals       = 18;\n', '        accTDE         = _accTDE;\n', '        accFoundCDF    = _accFoundCDF;\n', '        accFoundNDF1   = _accFoundNDF1;\n', '        accFoundNDF2   = _accFoundNDF2;\n', '        accFoundNDF3   = _accFoundNDF3;\n', '        \n', '        accTeam        = _accTeam;\n', '        accBounty      = _accBounty;\n', '        _totalSupply   = _initialSupply * (10 ** uint256(decimals));// All ARR tokens in the world\n', '        \n', '       //Initial token distribution\n', '        _balances[_accTDE]       = 1104000000 * (10 ** uint256(decimals)); // TDE,      36.8%=28.6+8.2 \n', '        _balances[_accFoundCDF]  = 1251000000 * (10 ** uint256(decimals)); // CDF,      41.7%\n', '        _balances[_accFoundNDF1] =  150000000 * (10 ** uint256(decimals)); // 0.50*NDF, 10.0%\n', '        _balances[_accFoundNDF2] =  105000000 * (10 ** uint256(decimals)); // 0.35*NDF, 10.0%\n', '        _balances[_accFoundNDF3] =   45000000 * (10 ** uint256(decimals)); // 0.15*NDF, 10.0%\n', '        _balances[_accTeam]      =  300000000 * (10 ** uint256(decimals)); // team,     10.0%\n', '        _balances[_accBounty]    =   45000000 * (10 ** uint256(decimals)); // Bounty,    1.5%\n', '        require(  _totalSupply ==  3000000000 * (10 ** uint256(decimals)), "Total Supply exceeded!!!");\n', '        emit Transfer(address(0), _accTDE,       1104000000 * (10 ** uint256(decimals)));\n', '        emit Transfer(address(0), _accFoundCDF,  1251000000 * (10 ** uint256(decimals)));\n', '        emit Transfer(address(0), _accFoundNDF1,  150000000 * (10 ** uint256(decimals)));\n', '        emit Transfer(address(0), _accFoundNDF2,  105000000 * (10 ** uint256(decimals)));\n', '        emit Transfer(address(0), _accFoundNDF3,   45000000 * (10 ** uint256(decimals)));\n', '        emit Transfer(address(0), _accTeam,       300000000 * (10 ** uint256(decimals)));\n', '        emit Transfer(address(0), _accBounty,      45000000 * (10 ** uint256(decimals)));\n', '        //initisl freeze\n', '        frozenAccounts[_accTeam]      = TDE_FINISH + 31536000; //+3600*24*365 sec\n', '        frozenAccounts[_accFoundNDF2] = TDE_FINISH + 31536000; //+3600*24*365 sec\n', '        frozenAccounts[_accFoundNDF3] = TDE_FINISH + 63158400; //+(3600*24*365)*2 +3600*24(leap year 2020)\n', '        emit NewFreeze(_accTeam,        TDE_FINISH + 31536000);\n', '        emit NewFreeze(_accFoundNDF2,   TDE_FINISH + 31536000);\n', '        emit NewFreeze(_accFoundNDF3,   TDE_FINISH + 63158400);\n', '\n', '    }\n', '    \n', '    modifier onlyTokenKeeper() {\n', '        require(\n', '            msg.sender == accTDE || \n', '            msg.sender == accFoundCDF ||\n', '            msg.sender == accFoundNDF1 ||\n', '            msg.sender == accBounty\n', '        );\n', '        _;\n', '    }\n', '\n', '    function() external { } \n', '\n', '    /**\n', '     * @dev Returns standart ERC20 result with frozen accounts check\n', '     */\n', '    function transfer(address _to, uint256 _value) public  returns (bool) {\n', '        require(frozenAccounts[msg.sender] < now);\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns standart ERC20 result with frozen accounts check\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public  returns (bool) {\n', '        require(frozenAccounts[_from] < now);\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns standart ERC20 result with frozen accounts check\n', '     */\n', '    function approve(address _spender, uint256 _value) public  returns (bool) {\n', '        require(frozenAccounts[msg.sender] < now);\n', '        return super.approve(_spender, _value);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns standart ERC20 result with frozen accounts check\n', '     */\n', '    function increaseAllowance(address _spender, uint _addedValue) public  returns (bool success) {\n', '        require(frozenAccounts[msg.sender] < now);\n', '        return super.increaseAllowance(_spender, _addedValue);\n', '    }\n', '    \n', '    /**\n', '     * @dev Returns standart ERC20 result with frozen accounts check\n', '     */\n', '    function decreaseAllowance(address _spender, uint _subtractedValue) public  returns (bool success) {\n', '        require(frozenAccounts[msg.sender] < now);\n', '        return super.decreaseAllowance(_spender, _subtractedValue);\n', '    }\n', '\n', '    \n', '    /**\n', '     * @dev Batch transfer function. Allow to save up 50% of gas\n', '     */\n', '    function multiTransfer(address[] calldata  _investors, uint256[] calldata   _value )  \n', '        external \n', '        onlyTokenKeeper \n', '        returns (uint256 _batchAmount)\n', '    {\n', '        require(_investors.length <= 255); //audit recommendation\n', '        require(_value.length == _investors.length);\n', '        uint8      cnt = uint8(_investors.length);\n', '        uint256 amount = 0;\n', '        for (uint i=0; i<cnt; i++){\n', '            amount = amount.add(_value[i]);\n', '            require(_investors[i] != address(0));\n', '            _balances[_investors[i]] = _balances[_investors[i]].add(_value[i]);\n', '            emit Transfer(msg.sender, _investors[i], _value[i]);\n', '        }\n', '        require(amount <= _balances[msg.sender]);\n', '        _balances[msg.sender] = _balances[msg.sender].sub(amount);\n', '        emit BatchDistrib(cnt, amount);\n', '        return amount;\n', '    }\n', '  \n', '    /**\n', '     * @dev Owner can claim any tokens that transfered to this contract address\n', '     */\n', '    function reclaimToken(ERC20 token) external onlyOwner {\n', '        require(address(token) != address(0));\n', '        uint256 balance = token.balanceOf(address(this));\n', '        token.transfer(owner, balance);\n', '    }\n', '}\n', '  //***************************************************************\n', '  // Based on best practice of https://github.com/Open Zeppelin/zeppelin-solidity\n', '  // Adapted and amended by IBERGroup; \n', '  // Code released under the MIT License(see git root).\n', '  ////**************************************************************']