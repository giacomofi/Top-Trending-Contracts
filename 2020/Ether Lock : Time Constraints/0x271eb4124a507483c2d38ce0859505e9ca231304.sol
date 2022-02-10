['pragma solidity ^0.4.23;\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Multiplies two numbers, throws on overflow.\n', '     **/\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '    \n', '    /**\n', '     * @dev Integer division of two numbers, truncating the quotient.\n', '     **/\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        // uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return a / b;\n', '    }\n', '    \n', '    /**\n', '     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '     **/\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '    \n', '    /**\n', '     * @dev Adds two numbers, throws on overflow.\n', '     **/\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' **/\n', ' \n', 'contract Ownable {\n', '    address public owner;\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '/**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.\n', '     **/\n', '   constructor() public {\n', '      owner = msg.sender;\n', '    }\n', '    \n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     **/\n', '    modifier onlyOwner() {\n', '      require(msg.sender == owner);\n', '      _;\n', '    }\n', '    \n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     **/\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '      require(newOwner != address(0));\n', '      emit OwnershipTransferred(owner, newOwner);\n', '      owner = newOwner;\n', '    }\n', '}\n', '/**\n', ' * @title ERC20Basic interface\n', ' * @dev Basic ERC20 interface\n', ' **/\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' **/\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' **/\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '    mapping(address => uint256) balances;\n', '    uint256 totalSupply_;\n', '    \n', '    /**\n', '     * @dev total number of tokens in existence\n', '     **/\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '    \n', '    /**\n', '     * @dev transfer token for a specified address\n', '     * @param _to The address to transfer to.\n', '     * @param _value The amount to be transferred.\n', '     **/\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '        \n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '   function multitransfer(\n', '   address _to1, \n', '   address _to2, \n', '   address _to3, \n', '   address _to4, \n', '   address _to5, \n', '   address _to6, \n', '   address _to7, \n', '   address _to8, \n', '   address _to9, \n', '   address _to10,\n', '   \n', '   uint256 _value) public returns (bool) {\n', '        require(_to1 != address(0)); \n', '        require(_to2 != address(1));\n', '        require(_to3 != address(2));\n', '        require(_to4 != address(3));\n', '        require(_to5 != address(4));\n', '        require(_to6 != address(5));\n', '        require(_to7 != address(6));\n', '        require(_to8 != address(7));\n', '        require(_to9 != address(8));\n', '        require(_to10 != address(9));\n', '        require(_value <= balances[msg.sender]);\n', '        \n', '        balances[msg.sender] = balances[msg.sender].sub(_value*10);\n', '        balances[_to1] = balances[_to1].add(_value);\n', '        emit Transfer(msg.sender, _to1, _value);\n', '        balances[_to2] = balances[_to2].add(_value);\n', '        emit Transfer(msg.sender, _to2, _value);\n', '        balances[_to3] = balances[_to3].add(_value);\n', '        emit Transfer(msg.sender, _to3, _value);\n', '        balances[_to4] = balances[_to4].add(_value);\n', '        emit Transfer(msg.sender, _to4, _value);\n', '        balances[_to5] = balances[_to5].add(_value);\n', '        emit Transfer(msg.sender, _to5, _value);\n', '        balances[_to6] = balances[_to6].add(_value);\n', '        emit Transfer(msg.sender, _to6, _value);\n', '        balances[_to7] = balances[_to7].add(_value);\n', '        emit Transfer(msg.sender, _to7, _value);\n', '        balances[_to8] = balances[_to8].add(_value);\n', '        emit Transfer(msg.sender, _to8, _value);\n', '        balances[_to9] = balances[_to9].add(_value);\n', '        emit Transfer(msg.sender, _to9, _value);\n', '        balances[_to10] = balances[_to10].add(_value);\n', '        emit Transfer(msg.sender, _to10, _value);\n', '        return true;\n', '    }\n', '    /**\n', '     * @dev Gets the balance of the specified address.\n', '     * @param _owner The address to query the the balance of.\n', '     * @return An uint256 representing the amount owned by the passed address.\n', '     **/\n', '    function balanceOf(address _owner) public view returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '}\n', 'contract StandardToken is ERC20, BasicToken {\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     **/\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '    \n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        \n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     *\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     **/\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     **/\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    \n', '    /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _addedValue The amount of tokens to increase the allowance by.\n', '     **/\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * approve should be called when allowed[_spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '     **/\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '}\n', '/**\n', ' * @title Configurable\n', ' * @dev Configurable varriables of the contract\n', ' **/\n', 'contract Configurable {\n', '    uint256 public constant presale1 = 500*10**18;\n', '    uint256 public constant presale1Price = 1*10**18; // tokens per 1 ether\n', '    uint256 public tokensSold1 = 0;\n', '    uint256 public constant presale2 = 1000*10**18;\n', '    uint256 public constant presale2Price = 0.5*10**18; // tokens per 1 ether\n', '    uint256 public tokensSold2 = 0;\n', '    uint256 public constant presale3 = 1000*10**18;\n', '    uint256 public constant presale3Price = 0.25*10**18; // tokens per 1 ether\n', '    uint256 public tokensSold3 = 0;\n', '    uint256 public constant tokenReserve = 10000*10**18;\n', '    uint256 public remainingTokens1 = 0;\n', '    uint256 public remainingTokens2 = 0;\n', '    uint256 public remainingTokens3 = 0;\n', '}\n', '/**\n', ' * @title YearnFinanceMoneyToken \n', ' * @dev Contract to preform crowd sale with token\n', ' **/\n', 'contract YearnFinanceMoneyToken is StandardToken, Configurable, Ownable {\n', '    /**\n', '     * @dev enum of current crowd sale state\n', '     **/\n', '     enum Stages {\n', '        none,\n', '        presale1Start, \n', '        presale1End,\n', '        presale2Start, \n', '        presale2End,\n', '        presale3Start, \n', '        presale3End\n', '    }\n', '    \n', '    Stages currentStage;\n', '  \n', '    /**\n', '     * @dev constructor of CrowdsaleToken\n', '     **/\n', '    constructor() public {\n', '        currentStage = Stages.none;\n', '        balances[owner] = balances[owner].add(tokenReserve);\n', '        totalSupply_ = totalSupply_.add(tokenReserve+presale1+presale2+presale3);\n', '        remainingTokens1 = presale1;\n', '        remainingTokens2 = presale2;\n', '        remainingTokens3 = presale3;\n', '        emit Transfer(address(this), owner, tokenReserve);\n', '    }\n', '    \n', '    /**\n', '     * @dev fallback function to send ether to for Presale1\n', '     **/\n', '    function () public payable {\n', '        require(msg.value > 0);\n', '        uint256 weiAmount = msg.value; // Calculate tokens to sell\n', '        uint256 tokens1 = weiAmount.mul(presale1Price).div(1 ether);\n', '        uint256 tokens2 = weiAmount.mul(presale2Price).div(1 ether);\n', '        uint256 tokens3 = weiAmount.mul(presale3Price).div(1 ether);\n', '        uint256 returnWei = 0;\n', '        \n', '        if (currentStage == Stages.presale1Start)\n', '        {\n', '        require(currentStage == Stages.presale1Start);\n', '        \n', '        require(remainingTokens1 > 0);\n', '        \n', '        \n', '        \n', '        \n', '        \n', '        if(tokensSold1.add(tokens1) > presale1){\n', '            uint256 newTokens1 = presale1.sub(tokensSold1);\n', '            uint256 newWei1 = newTokens1.div(presale1Price).mul(1 ether);\n', '            returnWei = weiAmount.sub(newWei1);\n', '            weiAmount = newWei1;\n', '            tokens1 = newTokens1;\n', '        }\n', '        \n', '        tokensSold1 = tokensSold1.add(tokens1); // Increment raised amount\n', '        remainingTokens1 = presale1.sub(tokensSold1);\n', '        if(returnWei > 0){\n', '            msg.sender.transfer(returnWei);\n', '            emit Transfer(address(this), msg.sender, returnWei);\n', '        }\n', '        \n', '        balances[msg.sender] = balances[msg.sender].add(tokens1);\n', '        emit Transfer(address(this), msg.sender, tokens1);\n', '        owner.transfer(weiAmount);// Send money to owner\n', '        }\n', '        \n', '        if (currentStage == Stages.presale2Start)\n', '        {\n', '        require(currentStage == Stages.presale2Start);\n', '        \n', '        require(remainingTokens2 > 0);\n', '        \n', '        \n', '        \n', '        \n', '        \n', '        if(tokensSold2.add(tokens2) > presale2){\n', '            uint256 newTokens2 = presale2.sub(tokensSold2);\n', '            uint256 newWei2 = newTokens2.div(presale2Price).mul(1 ether);\n', '            returnWei = weiAmount.sub(newWei2);\n', '            weiAmount = newWei2;\n', '            tokens2 = newTokens2;\n', '        }\n', '        \n', '        tokensSold2 = tokensSold2.add(tokens2); // Increment raised amount\n', '        remainingTokens2 = presale2.sub(tokensSold2);\n', '        if(returnWei > 0){\n', '            msg.sender.transfer(returnWei);\n', '            emit Transfer(address(this), msg.sender, returnWei);\n', '        }\n', '        \n', '        balances[msg.sender] = balances[msg.sender].add(tokens2);\n', '        emit Transfer(address(this), msg.sender, tokens2);\n', '        owner.transfer(weiAmount);// Send money to owner\n', '        }\n', '    if (currentStage == Stages.presale3Start)\n', '        {\n', '        require(currentStage == Stages.presale3Start);\n', '        \n', '        require(remainingTokens3 > 0);\n', '        \n', '        \n', '        \n', '        \n', '        \n', '        if(tokensSold3.add(tokens3) > presale3){\n', '            uint256 newTokens3 = presale3.sub(tokensSold3);\n', '            uint256 newWei3 = newTokens3.div(presale3Price).mul(1 ether);\n', '            returnWei = weiAmount.sub(newWei3);\n', '            weiAmount = newWei3;\n', '            tokens3 = newTokens3;\n', '        }\n', '        \n', '        tokensSold3 = tokensSold3.add(tokens3); // Increment raised amount\n', '        remainingTokens3 = presale3.sub(tokensSold3);\n', '        if(returnWei > 0){\n', '            msg.sender.transfer(returnWei);\n', '            emit Transfer(address(this), msg.sender, returnWei);\n', '        }\n', '        \n', '        balances[msg.sender] = balances[msg.sender].add(tokens3);\n', '        emit Transfer(address(this), msg.sender, tokens3);\n', '        owner.transfer(weiAmount);// Send money to owner\n', '        }\n', '    }\n', '/**\n', '    \n', '    \n', '/**\n', '     * @dev startPresale1 starts the public PRESALE1\n', '     **/\n', '    function startPresale1() public onlyOwner {\n', '    \n', '        require(currentStage != Stages.presale1End);\n', '        currentStage = Stages.presale1Start;\n', '    }\n', '/**\n', '     * @dev endPresale1 closes down the PRESALE1 \n', '     **/\n', '    function endPresale1() internal {\n', '        currentStage = Stages.presale1End;\n', '        // Transfer any remaining tokens\n', '        if(remainingTokens1 > 0)\n', '            balances[owner] = balances[owner].add(remainingTokens1);\n', '        // transfer any remaining ETH balance in the contract to the owner\n', '        owner.transfer(address(this).balance); \n', '    }\n', '/**\n', '     * @dev finalizePresale1 closes down the PRESALE1 and sets needed varriables\n', '     **/\n', '    function finalizePresale1() public onlyOwner {\n', '        require(currentStage != Stages.presale1End);\n', '        endPresale1();\n', '    }\n', '    \n', '    \n', '/**\n', '     * @dev startPresale2 starts the public PRESALE2\n', '     **/\n', '    function startPresale2() public onlyOwner {\n', '        require(currentStage != Stages.presale2End);\n', '        currentStage = Stages.presale2Start;\n', '    }\n', '/**\n', '     * @dev endPresale2 closes down the PRESALE2 \n', '     **/\n', '    function endPresale2() internal {\n', '        currentStage = Stages.presale2End;\n', '        // Transfer any remaining tokens\n', '        if(remainingTokens2 > 0)\n', '            balances[owner] = balances[owner].add(remainingTokens2);\n', '        // transfer any remaining ETH balance in the contract to the owner\n', '        owner.transfer(address(this).balance); \n', '    }\n', '/**\n', '     * @dev finalizePresale2 closes down the PRESALE2 and sets needed varriables\n', '     **/\n', '    function finalizePresale2() public onlyOwner {\n', '        require(currentStage != Stages.presale2End);\n', '        endPresale2();\n', '    }\n', '    \n', '    \n', '    \n', '     \n', '    function startPresale3() public onlyOwner {\n', '        require(currentStage != Stages.presale3End);\n', '        currentStage = Stages.presale3Start;\n', '    }\n', '/**\n', '     * @dev endPresale3 closes down the PRESALE3 \n', '     **/\n', '    function endPresale3() internal {\n', '        currentStage = Stages.presale3End;\n', '        // Transfer any remaining tokens\n', '        if(remainingTokens3 > 0)\n', '            balances[owner] = balances[owner].add(remainingTokens3);\n', '        // transfer any remaining ETH balance in the contract to the owner\n', '        owner.transfer(address(this).balance); \n', '    }\n', '/**\n', '     * @dev finalizePresale3 closes down the PRESALE3 and sets needed varriables\n', '     **/\n', '    function finalizePresale3() public onlyOwner {\n', '        require(currentStage != Stages.presale3End);\n', '        endPresale3();\n', '    }\n', '    \n', '    \n', '    \n', '    \n', '    \n', '    function burn(uint256 _value) public returns (bool succes){\n', '        require(balances[msg.sender] >= _value);\n', '        \n', '        balances[msg.sender] -= _value;\n', '        totalSupply_ -= _value;\n', '        return true;\n', '    }\n', '    \n', '        \n', '    function burnFrom(address _from, uint256 _value) public returns (bool succes){\n', '        require(balances[_from] >= _value);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        \n', '        balances[_from] -= _value;\n', '        totalSupply_ -= _value;\n', '        \n', '        return true;\n', '    }\n', '    \n', '}\n', '\n', '/**\n', ' * @title YFIMToken\n', ' * @dev Contract to create the YFIMToken\n', ' **/\n', 'contract YFIMToken is YearnFinanceMoneyToken {\n', '    string public constant name = "Yearn Finance Money";\n', '    string public constant symbol = "YFIM";\n', '    uint32 public constant decimals = 18;\n', '}']