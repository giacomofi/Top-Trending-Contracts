['pragma solidity 0.5.11;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address payable public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '    * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '    * account.\n', '    */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address payable newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' */\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances. \n', ' */\n', 'contract BasicToken is ERC20Basic, Ownable {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of. \n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '    \n', '}\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    /**\n', '    * @dev Transfer tokens from one address to another\n', '    * @param _from address The address which you want to send tokens from\n', '    * @param _to address The address which you want to transfer to\n', '    * @param _value uint256 the amount of tokens to be transferred\n', '    */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(allowed[_from][msg.sender] >= _value);\n', '        require(balances[_from] >= _value);\n', '        require(balances[_to].add(_value) > balances[_to]); // Check for overflows\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _value The amount of tokens to be spent.\n', '    */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        // To change the approve amount you first have to reduce the addresses`\n', '        //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '        //  already 0 to mitigate the race condition described here:\n', '        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '    * @param _owner address The address which owns the funds.\n', '    * @param _spender address The address which will spend the funds.\n', '    * @return A uint256 specifying the amount of tokens still available for the spender.\n', '    */\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '    * approve should be called when allowed[_spender] == 0. To increment\n', '    * allowed value is better to use this function to avoid 2 calls (and wait until \n', '    * the first transaction is mined)\n', '    * From MonolithDAO Token.sol\n', '    */\n', '    function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is StandardToken {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '    address public founder;\n', '    \n', '    /**\n', '    * @dev modifier to allow actions only when the contract IS paused\n', '    */\n', '    modifier whenNotPaused() {\n', '        require(!paused || msg.sender == founder);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev modifier to allow actions only when the contract IS NOT paused\n', '    */\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev called by the owner to pause, triggers stopped state\n', '    */\n', '    function pause() public onlyOwner whenNotPaused {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '    /**\n', '    * @dev called by the owner to unpause, returns to normal state\n', '    */\n', '    function unpause() public onlyOwner whenPaused {\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '}\n', '\n', '\n', 'contract PausableToken is Pausable {\n', '\n', '    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    //The functions below surve no real purpose. Even if one were to approve another to spend\n', '    //tokens on their behalf, those tokens will still only be transferable when the token contract\n', '    //is not paused.\n', '\n', '    function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.approve(_spender, _value);\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {\n', '        return super.increaseApproval(_spender, _addedValue);\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {\n', '        return super.decreaseApproval(_spender, _subtractedValue);\n', '    }\n', '}\n', '\n', 'contract ForsageToken is PausableToken {\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '\n', '    /**\n', '    * @dev Constructor that gives the founder all of the existing tokens.\n', '    */\n', '    constructor() public {\n', '        name = "Forsage Coin"; \n', '        symbol = "FFI"; \n', '        decimals = 18; \n', '        totalSupply = 100000000*10**18;\n', '        \n', '        founder = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;\n', '\n', '        balances[msg.sender] = totalSupply;\n', '        emit Transfer(address(0), msg.sender, totalSupply);\n', '    }\n', '    \n', '    function destroy() public onlyOwner{\n', '        selfdestruct(owner);\n', '    }\n', '}\n', '\n', '/**\n', ' * This contract is created to enable purchase and selling of tokens for fixed price \n', ' **/\n', 'contract ForsageSale is Ownable {\n', '\n', '    using SafeMath for uint256;\n', '    \n', '    address token;\n', '    \n', '    /**\n', '     * Price of 1 token compared to wei. E.x. value of "1000" means that 1 token is traded for 1000 wei.\n', '     **/\n', '    uint price;\n', '    \n', '    event TokensBought(address _buyer, uint256 _amount);\n', '\n', '    event TokensSold(address _seller, uint256 _amount);\n', '    \n', '    constructor(address _token, uint256 _price) public {\n', '        setToken(_token);\n', '        setPrice(_price);\n', '    }\n', '    /**\n', '    * @dev Receive payment in ether and return tokens.\n', '    */\n', '    function buyTokens() payable public {\n', "        require(msg.value>=getPrice(),'Tx value cannot be lower than price of 1 token');\n", '        uint256 amount = msg.value.div(getPrice());\n', '        ERC20 erc20 = ERC20(token);\n', '        require(erc20.balanceOf(address(this))>=amount,"Sorry, token vendor does not possess enough tokens for this purchase");\n', '        erc20.transfer(msg.sender,amount);\n', '        emit TokensBought(msg.sender,amount);\n', '    }\n', '\n', '    /**\n', '    * @dev Receive payment in tokens and return ether. \n', '    * Only usable by accounts which allowed the smart contract to transfer tokens from their account.\n', '    */\n', '    function sellTokens(uint256 _amount) public {\n', "        require(_amount>0,'You cannot sell 0 tokens');\n", '        uint256 ethToSend = _amount.mul(getPrice());\n', "        require(address(this).balance>=ethToSend,'Sorry, vendor does not possess enough Ether to trade for your tokens');\n", '        ERC20 erc20 = ERC20(token);\n', '        require(erc20.balanceOf(msg.sender)>=_amount,"You cannot sell more tokens than you own on your balance");\n', '        require(erc20.allowance(msg.sender,address(this))>=_amount,"You need to allow this contract to transfer enough tokens from your account");\n', '        erc20.transferFrom(msg.sender,address(this),_amount);\n', '        msg.sender.transfer(ethToSend);\n', '        emit TokensSold(msg.sender,_amount);\n', '    }\n', '\n', '    /**\n', '     * Sets the price for tokens, both for purchase and sale\n', '     * */\n', '    function setPrice(uint256 _price) public onlyOwner {\n', '        require(_price>0);\n', '        price = _price;\n', '    }\n', '    \n', '    function getPrice() public view returns(uint256){\n', '        return price;\n', '    }\n', '\n', '    /**\n', "    * @dev Set ERC20 token which will be used to trade through this contract. Usable only by this contract's owner.\n", '    * @param _token The address of the ERC20 token contract.\n', '    */\n', '    function setToken(address _token) public onlyOwner {\n', '        token = _token;\n', '    }\n', '\n', '    /**\n', '    * @dev Get the address of ERC20 token which is used to trade through this contract.\n', '    */\n', '    function getToken() public view returns(address){\n', '        return token;\n', '    }\n', '    \n', '    /**\n', "     * Simple function for contract's owner to be able to refill contract's ether balance\n", '     * */\n', '    function refillEtherBalance() public payable onlyOwner{\n', '        \n', '    }\n', '    \n', '    function getSaleEtherBalance() public view onlyOwner returns(uint256){\n', '        return address(this).balance;\n', '    }\n', '\n', '    /**\n', "     * Allows owner to withdraw all ether from contract's balance\n", '     * */\n', '    function withdrawEther() public onlyOwner{\n', '        owner.transfer(address(this).balance);\n', '    }\n', '    \n', '    function getSaleTokenBalance() public view onlyOwner returns(uint256){\n', '        ERC20 erc20 = ERC20(token);\n', '        return erc20.balanceOf(address(this));\n', '    }\n', '\n', '    /**\n', "     * Allows owner to withdraw all tokens from contract's balance\n", '     * */\n', '    function withdrawTokens() public onlyOwner{\n', '        ERC20 erc20 = ERC20(token);\n', '        uint256 amount = erc20.balanceOf(address(this));\n', '        erc20.transfer(owner,amount);\n', '    }\n', '    \n', '    function destroy() public onlyOwner{\n', '        selfdestruct(owner);\n', '    }\n', '}']