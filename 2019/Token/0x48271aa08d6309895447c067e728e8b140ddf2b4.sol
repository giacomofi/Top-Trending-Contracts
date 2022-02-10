['pragma solidity ^0.5.8;\n', '\n', 'library SafeMath {\n', '    /**\n', '     * @dev Multiplies two unsigned integers, reverts on overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, "SafeMath: division by zero");\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Adds two unsigned integers, reverts on overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor () internal {\n', '        _owner = 0xfc0281163cFeDA9FbB3B18A72A27310B1725fD65;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @return the address of the owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @return true if `msg.sender` is the owner of the contract.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to relinquish control of the contract.\n', '     * It will not be possible to call the functions with the `onlyOwner`\n', '     * modifier anymore.\n', '     * @notice Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', 'interface IERC20 {\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address who) external view returns (uint256);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract ERC20 is IERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) private _balances;\n', '    mapping (address => mapping (address => uint256)) private _allowances;\n', '    uint256 private _totalSupply;\n', '\n', '    /**\n', '     * @dev Total number of tokens in existence.\n', '     */\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the balance of the specified address.\n', '     * @param owner The address to query the balance of.\n', '     * @return A uint256 representing the amount owned by the passed address.\n', '     */\n', '    function balanceOf(address owner) public view returns (uint256) {\n', '        return _balances[owner];\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param owner address The address which owns the funds.\n', '     * @param spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address owner, address spender) public view returns (uint256) {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer token to a specified address.\n', '     * @param to The address to transfer to.\n', '     * @param value The amount to be transferred.\n', '     */\n', '    function transfer(address to, uint256 value) public returns (bool) {\n', '        _transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param spender The address which will spend the funds.\n', '     * @param value The amount of tokens to be spent.\n', '     */\n', '    function approve(address spender, uint256 value) public returns (bool) {\n', '        _approve(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another.\n', '     * Note that while this function emits an Approval event, this is not required as per the specification,\n', '     * and other compliant implementations may not emit the event.\n', '     * @param from address The address which you want to send tokens from\n', '     * @param to address The address which you want to transfer to\n', '     * @param value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '        _transfer(from, to, value);\n', '        _approve(from, msg.sender, _allowances[from][msg.sender].sub(value));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     * approve should be called when _allowances[msg.sender][spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * Emits an Approval event.\n', '     * @param spender The address which will spend the funds.\n', '     * @param addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n', '        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     * approve should be called when _allowances[msg.sender][spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * Emits an Approval event.\n', '     * @param spender The address which will spend the funds.\n', '     * @param subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n', '        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer token for a specified addresses.\n', '     * @param from The address to transfer from.\n', '     * @param to The address to transfer to.\n', '     * @param value The amount to be transferred.\n', '     */\n', '    function _transfer(address from, address to, uint256 value) internal {\n', '        require(from != address(0), "ERC20: transfer from the zero address");\n', '        require(to != address(0), "ERC20: transfer to the zero address");\n', '\n', '        _balances[from] = _balances[from].sub(value);\n', '        _balances[to] = _balances[to].add(value);\n', '        emit Transfer(from, to, value);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function that mints an amount of the token and assigns it to\n', '     * an account. This encapsulates the modification of balances such that the\n', '     * proper events are emitted.\n', '     * @param account The account that will receive the created tokens.\n', '     * @param value The amount that will be created.\n', '     */\n', '    function _mint(address account, uint256 value) internal {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '\n', '        _totalSupply = _totalSupply.add(value);\n', '        _balances[account] = _balances[account].add(value);\n', '        emit Transfer(address(0), account, value);\n', '    }\n', '    \n', '    /**\n', "     * @dev Approve an address to spend another addresses' tokens.\n", '     * @param owner The address that owns the tokens.\n', '     * @param spender The address that will spend the tokens.\n', '     * @param value The number of tokens that can be spent.\n', '     */\n', '    function _approve(address owner, address spender, uint256 value) internal {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[owner][spender] = value;\n', '        emit Approval(owner, spender, value);\n', '    }\n', '}\n', '\n', 'contract CSCToken is ERC20, Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    string public constant name     = "Crypto Service Capital Token";\n', '    string public constant symbol   = "CSCT";\n', '    uint8  public constant decimals = 18;\n', '    \n', '    bool public mintingFinished = false;\n', '    mapping (address => bool) private _minters;\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '    \n', '    modifier canMint() {\n', '        require(!mintingFinished);\n', '        _;\n', '    }\n', '    \n', '    function isMinter(address minter) public view returns (bool) {\n', '        if (owner() == minter) {\n', '            return true;\n', '        }\n', '        return _minters[minter];\n', '    }\n', '    \n', '    modifier onlyMinter() {\n', '        require(isMinter(msg.sender), "Minter: caller is not the minter");\n', '        _;\n', '    }\n', '    \n', '    function addMinter(address _minter) external onlyOwner returns (bool) {\n', '        require(_minter != address(0));\n', '        _minters[_minter] = true;\n', '        return true;\n', '    }\n', '    \n', '    function removeMinter(address _minter) external onlyOwner returns (bool) {\n', '        require(_minter != address(0));\n', '        _minters[_minter] = false;\n', '        return true;\n', '    }\n', '    \n', '    function mint(address to, uint256 value) public onlyMinter returns (bool) {\n', '        _mint(to, value);\n', '        emit Mint(to, value);\n', '        return true;\n', '    }\n', '    \n', '    function finishMinting() onlyOwner canMint external returns (bool) {\n', '        mintingFinished = true;\n', '        emit MintFinished();\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract Crowdsale is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    uint256 public constant rate = 1000;                                           // How many token units a buyer gets per wei\n', '    uint256 public constant cap = 10000 ether;                                     // Maximum amount of funds\n', '\n', '    bool public isFinalized = false;                                               // End timestamps where investments are allowed\n', '    uint256 public startTime = 1559347199;                                         // 31-May-19 23:59:59 UTC\n', '    uint256 public endTime = 1577836799;                                           // 30-Dec-19 23:59:59 UTC\n', '\n', '    CSCToken public token;                                                         // CSCT token itself\n', '    address payable public wallet = 0x1524Aa69ef4BA327576FcF548f7dD14aEaC8CA18;    // Wallet of funds\n', '    uint256 public weiRaised;                                                      // Amount of raised money in wei\n', '\n', '    uint256 public firstBonus = 30;                                                // 1st bonus percentage\n', '    uint256 public secondBonus = 50;                                               // 2nd bonus percentage\n', '\n', '    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '    event Finalized();\n', '\n', '    constructor (CSCToken _CSCT) public {\n', '        assert(address(_CSCT) != address(0));\n', '        token = _CSCT;\n', '    }\n', '\n', '    function () external payable {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    // @return true if the transaction can buy tokens\n', '    function validPurchase() internal view returns (bool) {\n', '        require(!token.mintingFinished());\n', '        require(weiRaised <= cap);\n', '        require(now >= startTime);\n', '        require(now <= endTime);\n', '        require(msg.value >= 0.001 ether);\n', '\n', '        return true;\n', '    }\n', '    \n', '    function tokensForWei(uint weiAmount) public view returns (uint tokens) {\n', '        tokens = weiAmount.mul(rate);\n', '        tokens = tokens.add(getBonus(tokens, weiAmount));\n', '    }\n', '    \n', '    function getBonus(uint256 _tokens, uint256 _weiAmount) public view returns (uint256) {\n', '        if (_weiAmount >= 30 ether) {\n', '            return _tokens.mul(secondBonus).div(100);\n', '        }\n', '        return _tokens.mul(firstBonus).div(100);\n', '    }\n', '\n', '    function buyTokens(address beneficiary) public payable {\n', '        require(beneficiary != address(0));\n', '        require(validPurchase());\n', '\n', '        uint256 weiAmount = msg.value;\n', '        uint256 tokens = tokensForWei(weiAmount);\n', '        weiRaised = weiRaised.add(weiAmount);\n', '\n', '        token.mint(beneficiary, tokens);\n', '        emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);\n', '\n', '        wallet.transfer(msg.value);\n', '    }\n', '\n', '    function setFirstBonus(uint256 _newBonus) onlyOwner external {\n', '        firstBonus = _newBonus;\n', '    }\n', '\n', '    function setSecondBonus(uint256 _newBonus) onlyOwner external {\n', '        secondBonus = _newBonus;\n', '    }\n', '\n', '    function changeEndTime(uint256 _newTime) onlyOwner external {\n', '        require(endTime >= now);\n', '        endTime = _newTime;\n', '    }\n', '\n', "    // Calls the contract's finalization function.\n", '    function finalize() onlyOwner external {\n', '        require(!isFinalized);\n', '\n', '        endTime = now;\n', '        isFinalized = true;\n', '        emit Finalized();\n', '    }\n', '\n', '    // @return true if crowdsale event has ended\n', '    function hasEnded() external view returns (bool) {\n', '        return now > endTime;\n', '    }\n', '}']