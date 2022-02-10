['pragma solidity ^0.4.21;\n', '/**\n', '* Math operations with safety checks\n', '*/\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        //assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c>=a && c>=b);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    /**\n', '      * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '      * account.\n', '      */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '      * @dev Throws if called by any account other than the owner.\n', '      */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    /**\n', '    * @dev Fix for the ERC20 short address attack.\n', '    */    \n', '    modifier onlyPayloadSize(uint size) {\n', '        assert(msg.data.length >= size + 4);\n', '        _;\n', '    }\n', '}\n', '\n', '\n', 'contract ATCCOIN is Ownable{\n', '    using SafeMath for uint;\n', '    string public name;     \n', '    string public symbol;\n', '    uint8 public decimals;  \n', '    uint private _totalSupply;\n', '    uint public basisPointsRate = 0;\n', '    uint public minimumFee = 0;\n', '    uint public maximumFee = 0;\n', '\n', '    \n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) internal balances;\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '    \n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    /* notify about transfer to client*/\n', '    event Transfer(\n', '        address indexed from,\n', '        address indexed to,\n', '        uint256 value\n', '    );\n', '    \n', '    /* notify about approval to client*/\n', '    event Approval(\n', '        address indexed _owner,\n', '        address indexed _spender,\n', '        uint256 _value\n', '    );\n', '    \n', '    /* notify about basisPointsRate to client*/\n', '    event Params(\n', '        uint feeBasisPoints,\n', '        uint maximumFee,\n', '        uint minimumFee\n', '    );\n', '    \n', '    // Called when new token are issued\n', '    event Issue(\n', '        uint amount\n', '    );\n', '\n', '    // Called when tokens are redeemed\n', '    event Redeem(\n', '        uint amount\n', '    );\n', '    \n', '    /*\n', '        The contract can be initialized with a number of tokens\n', '        All the tokens are deposited to the owner address\n', '        @param _balance Initial supply of the contract\n', '        @param _name Token Name\n', '        @param _symbol Token symbol\n', '        @param _decimals Token decimals\n', '    */\n', '    constructor() public {\n', '        name = &#39;ATCCOIN&#39;; // Set the name for display purposes\n', '        symbol = &#39;ATCC&#39;; // Set the symbol for display purposes\n', '        decimals = 18; // Amount of decimals for display purposes\n', '        _totalSupply = 410000000 * 10**uint(decimals); // Update total supply\n', '        balances[msg.sender] = _totalSupply; // Give the creator all initial tokens\n', '    }\n', '    \n', '    /*\n', '        @dev Total number of tokens in existence\n', '    */\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '   \n', '   /*\n', '    @dev Gets the balance of the specified address.\n', '  * @param owner The address to query the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '    function balanceOf(address owner) public view returns (uint256) {\n', '        return balances[owner];\n', '    }\n', '    /*\n', '        @dev transfer token for a specified address\n', '        @param _to The address to transfer to.\n', '        @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256  _value) public onlyPayloadSize(2 * 32){\n', '        //Calculate Fees from basis point rate \n', '        uint fee = (_value.mul(basisPointsRate)).div(1000);\n', '        if (fee > maximumFee) {\n', '            fee = maximumFee;\n', '        }\n', '        if (fee < minimumFee) {\n', '            fee = minimumFee;\n', '        }\n', '        // Prevent transfer to 0x0 address.\n', '        require (_to != 0x0);\n', '        //check receiver is not owner\n', '        require(_to != address(0));\n', '        //Check transfer value is > 0;\n', '        require (_value > 0); \n', '        // Check if the sender has enough\n', '        require (balances[msg.sender] > _value);\n', '        // Check for overflows\n', '        require (balances[_to].add(_value) > balances[_to]);\n', '        //sendAmount to receiver after deducted fee\n', '        uint sendAmount = _value.sub(fee);\n', '        // Subtract from the sender\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        // Add the same to the recipient\n', '        balances[_to] = balances[_to].add(sendAmount); \n', '        //Add fee to owner Account\n', '        if (fee > 0) {\n', '            balances[owner] = balances[owner].add(fee);\n', '            emit Transfer(msg.sender, owner, fee);\n', '        }\n', '        // Notify anyone listening that this transfer took place\n', '        emit Transfer(msg.sender, _to, _value);\n', '    }\n', '    \n', '    /*\n', '        @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '        @param _spender The address which will spend the funds.\n', '        @param _value The amount of tokens to be spent.\n', '    */\n', '    function approve(address _spender, uint256 _value) public onlyPayloadSize(2 * 32) returns (bool success) {\n', '        //Check approve value is > 0;\n', '        require (_value > 0);\n', '        //Check balance of owner is greater than\n', '        require (balances[owner] > _value);\n', '        //check _spender is not itself\n', '        require (_spender != msg.sender);\n', '        //Allowed token to _spender\n', '        allowed[msg.sender][_spender] = _value;\n', '        //Notify anyone listening that this Approval took place\n', '        emit Approval(msg.sender,_spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    /*\n', '        @dev Transfer tokens from one address to another\n', '        @param _from address The address which you want to send tokens from\n', '        @param _to address The address which you want to transfer to\n', '        @param _value uint the amount of tokens to be transferred\n', '    */\n', '    function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(2 * 32) returns (bool success) {\n', '        //Calculate Fees from basis point rate \n', '        uint fee = (_value.mul(basisPointsRate)).div(1000);\n', '        if (fee > maximumFee) {\n', '                fee = maximumFee;\n', '        }\n', '        if (fee < minimumFee) {\n', '            fee = minimumFee;\n', '        }\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require (_to != 0x0);\n', '        //check receiver is not owner\n', '        require(_to != address(0));\n', '        //Check transfer value is > 0;\n', '        require (_value > 0); \n', '        // Check if the sender has enough\n', '        require(_value < balances[_from]);\n', '        // Check for overflows\n', '        require (balances[_to].add(_value) > balances[_to]);\n', '        // Check allowance\n', '        require (_value <= allowed[_from][msg.sender]);\n', '        uint sendAmount = _value.sub(fee);\n', '        balances[_from] = balances[_from].sub(_value);// Subtract from the sender\n', '        balances[_to] = balances[_to].add(sendAmount); // Add the same to the recipient\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        if (fee > 0) {\n', '            balances[owner] = balances[owner].add(fee);\n', '            emit Transfer(_from, owner, fee);\n', '        }\n', '        emit Transfer(_from, _to, sendAmount);\n', '        return true;\n', '    }\n', '    \n', '    /*\n', '        @dev Function to check the amount of tokens than an owner allowed to a spender.\n', '        @param _owner address The address which owns the funds.\n', '        @param _spender address The address which will spend the funds.\n', '        @return A uint specifying the amount of tokens still available for the spender.\n', '    */\n', '    function allowance(address _from, address _spender) public view returns (uint remaining) {\n', '        return allowed[_from][_spender];\n', '    }\n', '    \n', '    /*\n', '        @dev Function to set the basis point rate .\n', '        @param newBasisPoints uint which is <= 9.\n', '    */\n', '    function setParams(uint newBasisPoints,uint newMaxFee,uint newMinFee) public onlyOwner {\n', '        // Ensure transparency by hardcoding limit beyond which fees can never be added\n', '        require(newBasisPoints <= 9);\n', '        require(newMaxFee <= 100);\n', '        require(newMinFee <= 5);\n', '        basisPointsRate = newBasisPoints;\n', '        maximumFee = newMaxFee.mul(10**uint(decimals));\n', '        minimumFee = newMinFee.mul(10**uint(decimals));\n', '        emit Params(basisPointsRate, maximumFee, minimumFee);\n', '    }\n', '    /*\n', '    Issue a new amount of tokens\n', '    these tokens are deposited into the owner address\n', '    @param _amount Number of tokens to be issued\n', '    */\n', '    function increaseSupply(uint amount) public onlyOwner {\n', '        require(amount <= 10000000);\n', '        amount = amount.mul(10**uint(decimals));\n', '        require(_totalSupply.add(amount) > _totalSupply);\n', '        require(balances[owner].add(amount) > balances[owner]);\n', '        balances[owner] = balances[owner].add(amount);\n', '        _totalSupply = _totalSupply.add(amount);\n', '        emit Issue(amount);\n', '    }\n', '    \n', '    /*\n', '    Redeem tokens.\n', '    These tokens are withdrawn from the owner address\n', '    if the balance must be enough to cover the redeem\n', '    or the call will fail.\n', '    @param _amount Number of tokens to be issued\n', '    */\n', '    function decreaseSupply(uint amount) public onlyOwner {\n', '        require(amount <= 10000000);\n', '        amount = amount.mul(10**uint(decimals));\n', '        require(_totalSupply >= amount);\n', '        require(balances[owner] >= amount);\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        balances[owner] = balances[owner].sub(amount);\n', '        emit Redeem(amount);\n', '    }\n', '}']
['pragma solidity ^0.4.21;\n', '/**\n', '* Math operations with safety checks\n', '*/\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', "        //assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c>=a && c>=b);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    /**\n', '      * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '      * account.\n', '      */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '      * @dev Throws if called by any account other than the owner.\n', '      */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    /**\n', '    * @dev Fix for the ERC20 short address attack.\n', '    */    \n', '    modifier onlyPayloadSize(uint size) {\n', '        assert(msg.data.length >= size + 4);\n', '        _;\n', '    }\n', '}\n', '\n', '\n', 'contract ATCCOIN is Ownable{\n', '    using SafeMath for uint;\n', '    string public name;     \n', '    string public symbol;\n', '    uint8 public decimals;  \n', '    uint private _totalSupply;\n', '    uint public basisPointsRate = 0;\n', '    uint public minimumFee = 0;\n', '    uint public maximumFee = 0;\n', '\n', '    \n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) internal balances;\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '    \n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    /* notify about transfer to client*/\n', '    event Transfer(\n', '        address indexed from,\n', '        address indexed to,\n', '        uint256 value\n', '    );\n', '    \n', '    /* notify about approval to client*/\n', '    event Approval(\n', '        address indexed _owner,\n', '        address indexed _spender,\n', '        uint256 _value\n', '    );\n', '    \n', '    /* notify about basisPointsRate to client*/\n', '    event Params(\n', '        uint feeBasisPoints,\n', '        uint maximumFee,\n', '        uint minimumFee\n', '    );\n', '    \n', '    // Called when new token are issued\n', '    event Issue(\n', '        uint amount\n', '    );\n', '\n', '    // Called when tokens are redeemed\n', '    event Redeem(\n', '        uint amount\n', '    );\n', '    \n', '    /*\n', '        The contract can be initialized with a number of tokens\n', '        All the tokens are deposited to the owner address\n', '        @param _balance Initial supply of the contract\n', '        @param _name Token Name\n', '        @param _symbol Token symbol\n', '        @param _decimals Token decimals\n', '    */\n', '    constructor() public {\n', "        name = 'ATCCOIN'; // Set the name for display purposes\n", "        symbol = 'ATCC'; // Set the symbol for display purposes\n", '        decimals = 18; // Amount of decimals for display purposes\n', '        _totalSupply = 410000000 * 10**uint(decimals); // Update total supply\n', '        balances[msg.sender] = _totalSupply; // Give the creator all initial tokens\n', '    }\n', '    \n', '    /*\n', '        @dev Total number of tokens in existence\n', '    */\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '   \n', '   /*\n', '    @dev Gets the balance of the specified address.\n', '  * @param owner The address to query the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '    function balanceOf(address owner) public view returns (uint256) {\n', '        return balances[owner];\n', '    }\n', '    /*\n', '        @dev transfer token for a specified address\n', '        @param _to The address to transfer to.\n', '        @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256  _value) public onlyPayloadSize(2 * 32){\n', '        //Calculate Fees from basis point rate \n', '        uint fee = (_value.mul(basisPointsRate)).div(1000);\n', '        if (fee > maximumFee) {\n', '            fee = maximumFee;\n', '        }\n', '        if (fee < minimumFee) {\n', '            fee = minimumFee;\n', '        }\n', '        // Prevent transfer to 0x0 address.\n', '        require (_to != 0x0);\n', '        //check receiver is not owner\n', '        require(_to != address(0));\n', '        //Check transfer value is > 0;\n', '        require (_value > 0); \n', '        // Check if the sender has enough\n', '        require (balances[msg.sender] > _value);\n', '        // Check for overflows\n', '        require (balances[_to].add(_value) > balances[_to]);\n', '        //sendAmount to receiver after deducted fee\n', '        uint sendAmount = _value.sub(fee);\n', '        // Subtract from the sender\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        // Add the same to the recipient\n', '        balances[_to] = balances[_to].add(sendAmount); \n', '        //Add fee to owner Account\n', '        if (fee > 0) {\n', '            balances[owner] = balances[owner].add(fee);\n', '            emit Transfer(msg.sender, owner, fee);\n', '        }\n', '        // Notify anyone listening that this transfer took place\n', '        emit Transfer(msg.sender, _to, _value);\n', '    }\n', '    \n', '    /*\n', '        @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '        @param _spender The address which will spend the funds.\n', '        @param _value The amount of tokens to be spent.\n', '    */\n', '    function approve(address _spender, uint256 _value) public onlyPayloadSize(2 * 32) returns (bool success) {\n', '        //Check approve value is > 0;\n', '        require (_value > 0);\n', '        //Check balance of owner is greater than\n', '        require (balances[owner] > _value);\n', '        //check _spender is not itself\n', '        require (_spender != msg.sender);\n', '        //Allowed token to _spender\n', '        allowed[msg.sender][_spender] = _value;\n', '        //Notify anyone listening that this Approval took place\n', '        emit Approval(msg.sender,_spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    /*\n', '        @dev Transfer tokens from one address to another\n', '        @param _from address The address which you want to send tokens from\n', '        @param _to address The address which you want to transfer to\n', '        @param _value uint the amount of tokens to be transferred\n', '    */\n', '    function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(2 * 32) returns (bool success) {\n', '        //Calculate Fees from basis point rate \n', '        uint fee = (_value.mul(basisPointsRate)).div(1000);\n', '        if (fee > maximumFee) {\n', '                fee = maximumFee;\n', '        }\n', '        if (fee < minimumFee) {\n', '            fee = minimumFee;\n', '        }\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require (_to != 0x0);\n', '        //check receiver is not owner\n', '        require(_to != address(0));\n', '        //Check transfer value is > 0;\n', '        require (_value > 0); \n', '        // Check if the sender has enough\n', '        require(_value < balances[_from]);\n', '        // Check for overflows\n', '        require (balances[_to].add(_value) > balances[_to]);\n', '        // Check allowance\n', '        require (_value <= allowed[_from][msg.sender]);\n', '        uint sendAmount = _value.sub(fee);\n', '        balances[_from] = balances[_from].sub(_value);// Subtract from the sender\n', '        balances[_to] = balances[_to].add(sendAmount); // Add the same to the recipient\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        if (fee > 0) {\n', '            balances[owner] = balances[owner].add(fee);\n', '            emit Transfer(_from, owner, fee);\n', '        }\n', '        emit Transfer(_from, _to, sendAmount);\n', '        return true;\n', '    }\n', '    \n', '    /*\n', '        @dev Function to check the amount of tokens than an owner allowed to a spender.\n', '        @param _owner address The address which owns the funds.\n', '        @param _spender address The address which will spend the funds.\n', '        @return A uint specifying the amount of tokens still available for the spender.\n', '    */\n', '    function allowance(address _from, address _spender) public view returns (uint remaining) {\n', '        return allowed[_from][_spender];\n', '    }\n', '    \n', '    /*\n', '        @dev Function to set the basis point rate .\n', '        @param newBasisPoints uint which is <= 9.\n', '    */\n', '    function setParams(uint newBasisPoints,uint newMaxFee,uint newMinFee) public onlyOwner {\n', '        // Ensure transparency by hardcoding limit beyond which fees can never be added\n', '        require(newBasisPoints <= 9);\n', '        require(newMaxFee <= 100);\n', '        require(newMinFee <= 5);\n', '        basisPointsRate = newBasisPoints;\n', '        maximumFee = newMaxFee.mul(10**uint(decimals));\n', '        minimumFee = newMinFee.mul(10**uint(decimals));\n', '        emit Params(basisPointsRate, maximumFee, minimumFee);\n', '    }\n', '    /*\n', '    Issue a new amount of tokens\n', '    these tokens are deposited into the owner address\n', '    @param _amount Number of tokens to be issued\n', '    */\n', '    function increaseSupply(uint amount) public onlyOwner {\n', '        require(amount <= 10000000);\n', '        amount = amount.mul(10**uint(decimals));\n', '        require(_totalSupply.add(amount) > _totalSupply);\n', '        require(balances[owner].add(amount) > balances[owner]);\n', '        balances[owner] = balances[owner].add(amount);\n', '        _totalSupply = _totalSupply.add(amount);\n', '        emit Issue(amount);\n', '    }\n', '    \n', '    /*\n', '    Redeem tokens.\n', '    These tokens are withdrawn from the owner address\n', '    if the balance must be enough to cover the redeem\n', '    or the call will fail.\n', '    @param _amount Number of tokens to be issued\n', '    */\n', '    function decreaseSupply(uint amount) public onlyOwner {\n', '        require(amount <= 10000000);\n', '        amount = amount.mul(10**uint(decimals));\n', '        require(_totalSupply >= amount);\n', '        require(balances[owner] >= amount);\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        balances[owner] = balances[owner].sub(amount);\n', '        emit Redeem(amount);\n', '    }\n', '}']