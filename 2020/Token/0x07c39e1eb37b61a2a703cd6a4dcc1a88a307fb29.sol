['// SPDX-License-Identifier: AGPL-3.0-or-later\n', '\n', 'pragma solidity ^0.7.0;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Unsigned math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Multiplies two unsigned integers, reverts on overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Adds two unsigned integers, reverts on overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '     * reverts when dividing by zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'interface IERC20 {\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address who) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * Owned contract\n', ' */\n', 'contract Owned {\n', '    address payable public owner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    constructor() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address payable _newOwner) public onlyOwner {\n', '        owner = _newOwner;\n', '        emit OwnershipTransferred(msg.sender, _newOwner);\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * Start and stop transfer;\n', ' */\n', 'contract BlackList is Owned {\n', '\n', '    mapping(address => bool) public _blacklist;\n', '\n', '    /**\n', '     * @notice lock account\n', '     */\n', '    function lockAccount(address _address) public onlyOwner {\n', '        _blacklist[_address] = true;\n', '    }\n', '\n', '    /**\n', '     * @notice Unlock account\n', '     */\n', '    function unlockAccount(address _address) public onlyOwner {\n', '        _blacklist[_address] = false;\n', '    }\n', '\n', '\n', '    /**\n', '     * @notice check address has in BlackList\n', '     */\n', '    function isLocked(address _address) public view returns (bool){\n', '        return _blacklist[_address];\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md\n', ' * Originally based on code by FirstBlood:\n', ' * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' *\n', ' * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for\n', " * all accounts just by listening to said events. Note that this isn't required by the specification, and other\n", ' * compliant implementations may not do it.\n', ' */\n', 'contract ERC20 is IERC20, Owned, BlackList {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) private _balances;\n', '\n', '    mapping(address => mapping(address => uint256)) private _allowed;\n', '\n', '    bool public _transferAble = false;\n', '\n', '    uint256 private _totalSupply;\n', '\n', '    /**\n', '     * @dev Total number of tokens in existence\n', '     */\n', '    function totalSupply() public view override returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the balance of the specified address.\n', '     * @param owner The address to query the balance of.\n', '     * @return An uint256 representing the amount owned by the passed address.\n', '     */\n', '    function balanceOf(address owner) public view override returns (uint256) {\n', '        return _balances[owner];\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param owner address The address which owns the funds.\n', '     * @param spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address owner, address spender) public view override returns (uint256) {\n', '        return _allowed[owner][spender];\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer token for a specified address\n', '     * @param to The address to transfer to.\n', '     * @param value The amount to be transferred.\n', '     */\n', '    function transfer(address to, uint256 value) public override returns (bool) {\n', '        _transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param spender The address which will spend the funds.\n', '     * @param value The amount of tokens to be spent.\n', '     */\n', '    function approve(address spender, uint256 value) public override returns (bool) {\n', '\n', '        // To change the approve amount you first have to reduce the addresses`\n', '        //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '        //  already 0 to mitigate the race condition described here:\n', '        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '        require(value == 0 || _allowed[msg.sender][spender] == 0);\n', '\n', '        _approve(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another.\n', '     * Note that while this function emits an Approval event, this is not required as per the specification,\n', '     * and other compliant implementations may not emit the event.\n', '     * @param from address The address which you want to send tokens from\n', '     * @param to address The address which you want to transfer to\n', '     * @param value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address from, address to, uint256 value) public override returns (bool) {\n', '        _transfer(from, to, value);\n', '        _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     * approve should be called when allowed_[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * Emits an Approval event.\n', '     * @param spender The address which will spend the funds.\n', '     * @param addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n', '        _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     * approve should be called when allowed_[_spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * Emits an Approval event.\n', '     * @param spender The address which will spend the funds.\n', '     * @param subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n', '        _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));\n', '        return true;\n', '    }\n', '\n', '\n', '    /**\n', '     * @notice set users can transaction token to others\n', '     */\n', '    function transferAble() public onlyOwner() {\n', '        _transferAble = true;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Transfer token for a specified addresses\n', '     * @param from The address to transfer from.\n', '     * @param to The address to transfer to.\n', '     * @param value The amount to be transferred.\n', '     */\n', '    function _transfer(address from, address to, uint256 value) internal {\n', '        require(to != address(0));\n', '        require(!isLocked(from), "The account has been locked");\n', '\n', '        if (owner != from && !_transferAble) {\n', '            revert("Transfers are not currently open");\n', '        }\n', '\n', '        _balances[from] = _balances[from].sub(value);\n', '        _balances[to] = _balances[to].add(value);\n', '        emit Transfer(from, to, value);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function that mints an amount of the token and assigns it to\n', '     * an account. This encapsulates the modification of balances such that the\n', '     * proper events are emitted.\n', '     * @param account The account that will receive the created tokens.\n', '     * @param value The amount that will be created.\n', '     */\n', '    function _mint(address account, uint256 value) internal {\n', '        require(account != address(0));\n', '\n', '        _totalSupply = _totalSupply.add(value);\n', '        _balances[account] = _balances[account].add(value);\n', '        emit Transfer(address(0), account, value);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function that burns an amount of the token of a given\n', '     * account.\n', '     * @param account The account whose tokens will be burnt.\n', '     * @param value The amount that will be burnt.\n', '     */\n', '    function _burn(address account, uint256 value) internal {\n', '        require(account != address(0));\n', '\n', '        _totalSupply = _totalSupply.sub(value);\n', '        _balances[account] = _balances[account].sub(value);\n', '        emit Transfer(account, address(0), value);\n', '    }\n', '\n', '    /**\n', "     * @dev Approve an address to spend another addresses' tokens.\n", '     * @param owner The address that owns the tokens.\n', '     * @param spender The address that will spend the tokens.\n', '     * @param value The number of tokens that can be spent.\n', '     */\n', '    function _approve(address owner, address spender, uint256 value) internal {\n', '        require(spender != address(0));\n', '        require(owner != address(0));\n', '\n', '        _allowed[owner][spender] = value;\n', '        emit Approval(owner, spender, value);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function that burns an amount of the token of a given\n', "     * account, deducting from the sender's allowance for said account. Uses the\n", '     * internal burn function.\n', '     * Emits an Approval event (reflecting the reduced allowance).\n', '     * @param account The account whose tokens will be burnt.\n', '     * @param value The amount that will be burnt.\n', '     */\n', '    function _burnFrom(address account, uint256 value) internal {\n', '        _burn(account, value);\n', '        _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20Detailed token\n', ' * @dev The decimals are only for visualization purposes.\n', ' * All the operations are done using the smallest and indivisible token unit,\n', ' * just as on Ethereum all the operations are done in wei.\n', ' */\n', 'abstract contract ERC20Detailed is IERC20 {\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '\n', '    constructor (string memory name, string memory symbol, uint8 decimals) {\n', '        _name = name;\n', '        _symbol = symbol;\n', '        _decimals = decimals;\n', '    }\n', '\n', '    /**\n', '     * @return the name of the token.\n', '     */\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    /**\n', '     * @return the symbol of the token.\n', '     */\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    /**\n', '     * @return the number of decimals of the token.\n', '     */\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '}\n', '\n', '\n', '/**\n', '* @dev Interface to use the receiveApproval method\n', '*/\n', 'interface TokenRecipient {\n', '\n', '    /**\n', '    * @notice Receives a notification of approval of the transfer\n', '    * @param _from Sender of approval\n', '    * @param _value  The amount of tokens to be spent\n', '    * @param _tokenContract Address of the token contract\n', '    * @param _extraData Extra data\n', '    */\n', '    function receiveApproval(address _from, uint256 _value, address _tokenContract, bytes calldata _extraData) external;\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', '* @title YFICore token\n', '* @notice ERC20 token\n', '* @dev Optional approveAndCall() functionality to notify a contract if an approve() has occurred.\n', '*/\n', "contract YFICoreToken is ERC20, ERC20Detailed('YFICore.finance', 'YFIR', 18) {\n", '    using SafeMath for uint256;\n', '    uint256 public totalPurchase = 0;\n', '    bool public _playable = true;\n', '\n', '    uint[4] public volume = [50e18, 250e18, 650e18, 1450e18];\n', '    uint[4] public price = [25e18, 20e18, 16e18, 12.8e18];\n', '    uint256 public min = 0.1e18;\n', '    uint256 public max = 50e18;\n', '\n', '    /**\n', '    * @notice Set amount of tokens\n', '    * @param _totalSupplyOfTokens Total number of tokens\n', '    */\n', '    constructor (uint256 _totalSupplyOfTokens) {\n', '        _mint(msg.sender, _totalSupplyOfTokens.mul(1e18));\n', '    }\n', '\n', '    /**\n', '    * @notice Approves and then calls the receiving contract\n', '    *\n', '    * @dev call the receiveApproval function on the contract you want to be notified.\n', '    * receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)\n', '    */\n', '    function approveAndCall(address _spender, uint256 _value, bytes calldata _extraData) external returns (bool success)\n', '    {\n', '        approve(_spender, _value);\n', '        TokenRecipient(_spender).receiveApproval(msg.sender, _value, address(this), _extraData);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @notice Set event start and end time;\n', '     * @param _value bool\n', '     */\n', '    function playable(bool _value) public onlyOwner() {\n', '        _playable = _value;\n', '    }\n', '\n', '    modifier inPlayable() {\n', '        require(_playable, "Not currently open for purchase");\n', '        _;\n', '    }\n', '\n', '    fallback() external payable {\n', '        revert();\n', '    }\n', '\n', '    /**\n', '     * @notice receive ehter callback\n', '     */\n', '    receive() external payable {\n', '        _swapToken(msg.sender, msg.value);\n', '    }\n', '\n', '    function buy() payable public {\n', '        _swapToken(msg.sender, msg.value);\n', '    }\n', '\n', '    /**\n', '     * @notice When receive ether Send TOKEN\n', '     */\n', '    function _swapToken(address buyer, uint256 amount) internal inPlayable() returns (uint256) {\n', '        require(amount > 0);\n', '        require(amount >= min, "Less than the minimum purchase");\n', "        require(amount <= max, 'Maximum purchase limit exceeded');\n", '        require(totalPurchase < volume[volume.length - 1], "Out of total purchase!");\n', '\n', '        (uint256 _swapBalance,uint256 overage) = _calculateToken(amount);\n', '        _swapBalance = _swapBalance.div(1e18);\n', '        // Automatically trade-able\n', '        if (_swapBalance <= 0) {\n', '            _transferAble = true;\n', '        }\n', '        require(_swapBalance <= totalSupply() && _swapBalance > 0);\n', '        require(overage <= amount);\n', '\n', '        // return _swapBalance;\n', '        _transfer(owner, buyer, _swapBalance);\n', '\n', '        if (overage > 0) {\n', '            msg.sender.transfer(overage);\n', '        }\n', '\n', '        return _swapBalance;\n', '    }\n', '\n', '\n', '    /**\n', '     * @notice withdraw balance to owner\n', '     */\n', '    function withdraw(uint256 amount) onlyOwner public {\n', '        uint256 etherBalance = address(this).balance;\n', '        require(amount < etherBalance);\n', '        owner.transfer(amount);\n', '    }\n', '\n', '    /**\n', '     * @notice burn token\n', '     */\n', '    function burn(address _account, uint256 value) onlyOwner public {\n', '        _burn(_account, value);\n', '    }\n', '\n', '    /**\n', '     * @notice calculate tokens\n', '     */\n', '    function _calculateToken(uint256 amount) internal returns (uint256, uint256){\n', '        // current round\n', '        uint round = _round(totalPurchase);\n', '        // current price\n', '        uint _price = price[round];\n', '        // current remaining of round\n', '        uint remaining = volume[round].sub(totalPurchase);\n', '        uint256 overage = 0;\n', '        uint256 res;\n', '        // when remaining > amount ,then amount * current price\n', '        if (remaining >= amount) {\n', '            totalPurchase = totalPurchase.add(amount);\n', '            res = amount.mul(_price);\n', '\n', '        } else {\n', '            // Available quota of the current segment, and recursively calculate the available quota of the next segment\n', '            overage = amount.sub(remaining);\n', '            totalPurchase = totalPurchase.add(remaining);\n', '            res = remaining.mul(_price);\n', '            // only check next segment.because Maximum is 50;\n', '            if (round < volume.length - 1) {\n', '                res = res.add(overage.mul(price[round + 1]));\n', '                totalPurchase = totalPurchase.add(overage);\n', '                overage = 0;\n', '            }\n', '        }\n', '        return (res, overage);\n', '    }\n', '\n', '\n', '    /**\n', '     * @notice Return current round\n', '     */\n', '    function _round(uint256 _value) internal view returns (uint){\n', '        for (uint i = 0; i < volume.length; i++) {\n', '            if (_value < volume[i]) {\n', '                return i;\n', '            }\n', '        }\n', '        return 0;\n', '    }\n', '}']