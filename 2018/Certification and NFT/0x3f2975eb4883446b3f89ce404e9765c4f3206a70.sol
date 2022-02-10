['pragma solidity ^0.4.21;\n', '\n', '\n', '/**\n', '* @title SafeMath\n', '* @dev Math operations with safety checks that throw on error\n', '*/\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '/**\n', '* @title Ownable\n', '* @dev The Ownable contract has an owner address, and provides basic authorization control \n', '* functions, this simplifies the implementation of "user permissions". \n', '*/ \n', 'contract Ownable {\n', '    address public owner;\n', '\n', '/** \n', '* @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '* account.\n', '*/\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '}\n', '\n', '\n', '/**\n', '* @title ERC20Basic\n', '* @dev Simpler version of ERC20 interface\n', '* @dev see https://github.com/ethereum/EIPs/issues/179\n', '*/\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public constant returns  (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', '* @title Basic token\n', '* @dev Basic version of StandardToken, with no allowances. \n', '*/\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of. \n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '}\n', '\n', '\n', '    /**\n', '    * @title ERC20 interface\n', '    * @dev see https://github.com/ethereum/EIPs/issues/20\n', '    */\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public constant returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', '* @title Standard ERC20 token\n', '*\n', '* @dev Implementation of the basic standard token.\n', '* @dev https://github.com/ethereum/EIPs/issues/20\n', '* @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', '*/\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    /**\n', '    * @dev Transfer tokens from one address to another\n', '    * @param _from address The address which you want to send tokens from\n', '    * @param _to address The address which you want to transfer to\n', '    * @param _value uint256 the amout of tokens to be transfered\n', '    */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '        balances[_to] = balances[_to].add(_value);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }       \n', '\n', '    /**\n', '    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _value The amount of tokens to be spent.\n', '    */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '    * @param _owner address The address which owns the funds.\n', '    * @param _spender address The address which will spend the funds.\n', '    * @return A uint256 specifing the amount of tokens still avaible for the spender.\n', '    */\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '}\n', '\n', '\n', '/*Token  Contract*/\n', 'contract ZXCToken is StandardToken, Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    // Token Information\n', '    string  public constant name = "MK7 Coin";\n', '    string  public constant symbol = "MK7";\n', '    uint8   public constant decimals = 18;\n', '\n', '    // Sale period1.\n', '    uint256 public startDate1;\n', '    uint256 public endDate1;\n', '\n', '    // Sale period2.\n', '    uint256 public startDate2;\n', '    uint256 public endDate2;\n', '\n', '    //SaleCap\n', '    uint256 public saleCap;\n', '\n', '    // Address Where Token are keep\n', '    address public tokenWallet;\n', '\n', '    // Address where funds are collected.\n', '    address public fundWallet;\n', '\n', '    // Amount of raised money in wei.\n', '    uint256 public weiRaised;\n', '\n', '    // Event\n', '    event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);\n', '    event PreICOTokenPushed(address indexed buyer, uint256 amount);\n', '\n', '    // Modifiers\n', '    modifier uninitialized() {\n', '        require(tokenWallet == 0x0);\n', '        require(fundWallet == 0x0);\n', '        _;\n', '    }\n', '\n', '    constructor() public {}\n', '    // Trigger with Transfer event\n', '    // Fallback function can be used to buy tokens\n', '    function () public payable {\n', '        buyTokens(msg.sender, msg.value);\n', '    }\n', '\n', '    //Initial Contract\n', '    function initialize(address _tokenWallet, address _fundWallet, uint256 _start1, uint256 _end1,\n', '                        uint256 _saleCap, uint256 _totalSupply) public\n', '                        onlyOwner uninitialized {\n', '        require(_start1 < _end1);\n', '        require(_tokenWallet != 0x0);\n', '        require(_fundWallet != 0x0);\n', '        require(_totalSupply >= _saleCap);\n', '\n', '        startDate1 = _start1;\n', '        endDate1 = _end1;\n', '        saleCap = _saleCap;\n', '        tokenWallet = _tokenWallet;\n', '        fundWallet = _fundWallet;\n', '        totalSupply = _totalSupply;\n', '\n', '        balances[tokenWallet] = saleCap;\n', '        balances[0xb1] = _totalSupply.sub(saleCap);\n', '    }\n', '\n', '    //Set PreSale Time\n', '    function setPeriod(uint period, uint256 _start, uint256 _end) public onlyOwner {\n', '        require(_end > _start);\n', '        if (period == 1) {\n', '            startDate1 = _start;\n', '            endDate1 = _end;\n', '        }else if (period == 2) {\n', '            require(_start > endDate1);\n', '            startDate2 = _start;\n', '            endDate2 = _end;      \n', '        }\n', '    }\n', '\n', '    // For pushing pre-ICO records\n', '    function sendForPreICO(address buyer, uint256 amount) public onlyOwner {\n', '        require(saleCap >= amount);\n', '\n', '        saleCap = saleCap - amount;\n', '        // Transfer\n', '        balances[tokenWallet] = balances[tokenWallet].sub(amount);\n', '        balances[buyer] = balances[buyer].add(amount);\n', '        emit PreICOTokenPushed(buyer, amount);\n', '        emit Transfer(tokenWallet, buyer, amount);\n', '    }\n', '\n', '    //Set SaleCap\n', '    function setSaleCap(uint256 _saleCap) public onlyOwner {\n', '        require(balances[0xb1].add(balances[tokenWallet]).sub(_saleCap) > 0);\n', '        uint256 amount=0;\n', '        //Check SaleCap\n', '        if (balances[tokenWallet] > _saleCap) {\n', '            amount = balances[tokenWallet].sub(_saleCap);\n', '            balances[0xb1] = balances[0xb1].add(amount);\n', '        } else {\n', '            amount = _saleCap.sub(balances[tokenWallet]);\n', '            balances[0xb1] = balances[0xb1].sub(amount);\n', '        }\n', '        balances[tokenWallet] = _saleCap;\n', '        saleCap = _saleCap;\n', '    }\n', '\n', '    //Calcute Bouns\n', '    function getBonusByTime(uint256 atTime) public constant returns (uint256) {\n', '        if (atTime < startDate1) {\n', '            return 0;\n', '        } else if (endDate1 > atTime && atTime > startDate1) {\n', '            return 5000;\n', '        } else if (endDate2 > atTime && atTime > startDate2) {\n', '            return 2500;\n', '        } else {\n', '            return 0;\n', '        }\n', '    }\n', '\n', '    function getBounsByAmount(uint256 etherAmount, uint256 tokenAmount) public pure returns (uint256) {\n', '        //Max 40%\n', '        uint256 bonusRatio = etherAmount.div(500 ether);\n', '        if (bonusRatio > 4) {\n', '            bonusRatio = 4;\n', '        }\n', '        uint256 bonusCount = SafeMath.mul(bonusRatio, 10);\n', '        uint256 bouns = SafeMath.mul(tokenAmount, bonusCount);\n', '        uint256 realBouns = SafeMath.div(bouns, 100);\n', '        return realBouns;\n', '    }\n', '\n', '    //Stop Contract\n', '    function finalize() public onlyOwner {\n', '        require(!saleActive());\n', '\n', '        // Transfer the rest of token to tokenWallet\n', '        balances[tokenWallet] = balances[tokenWallet].add(balances[0xb1]);\n', '        balances[0xb1] = 0;\n', '    }\n', '    \n', '    //Check SaleActive\n', '    function saleActive() public constant returns (bool) {\n', '        return (\n', '            (getCurrentTimestamp() >= startDate1 &&\n', '                getCurrentTimestamp() < endDate1 && saleCap > 0) ||\n', '            (getCurrentTimestamp() >= startDate2 &&\n', '                getCurrentTimestamp() < endDate2 && saleCap > 0)\n', '                );\n', '    }\n', '   \n', '    //Get CurrentTS\n', '    function getCurrentTimestamp() internal view returns (uint256) {\n', '        return now;\n', '    }\n', '\n', '     //Buy Token\n', '    function buyTokens(address sender, uint256 value) internal {\n', '        //Check Sale Status\n', '        require(saleActive());\n', '        \n', '        //Minum buying limit\n', '        require(value >= 0.5 ether);\n', '\n', '        // Calculate token amount to be purchased\n', '        uint256 bonus = getBonusByTime(getCurrentTimestamp());\n', '        uint256 amount = value.mul(bonus);\n', '        // If ETH > 500 the add 10%\n', '        if (getCurrentTimestamp() >= startDate1 && getCurrentTimestamp() < endDate1) {\n', '            uint256 p1Bouns = getBounsByAmount(value, amount);\n', '            amount = amount + p1Bouns;\n', '        }\n', '        // We have enough token to sale\n', '        require(saleCap >= amount);\n', '\n', '        // Transfer\n', '        balances[tokenWallet] = balances[tokenWallet].sub(amount);\n', '        balances[sender] = balances[sender].add(amount);\n', '        emit TokenPurchase(sender, value, amount);\n', '        emit Transfer(tokenWallet, sender, amount);\n', '        \n', '        saleCap = saleCap - amount;\n', '\n', '        // Update state.\n', '        weiRaised = weiRaised + value;\n', '\n', '        // Forward the fund to fund collection wallet.\n', '        fundWallet.transfer(msg.value);\n', '    }   \n', '}']
['pragma solidity ^0.4.21;\n', '\n', '\n', '/**\n', '* @title SafeMath\n', '* @dev Math operations with safety checks that throw on error\n', '*/\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '/**\n', '* @title Ownable\n', '* @dev The Ownable contract has an owner address, and provides basic authorization control \n', '* functions, this simplifies the implementation of "user permissions". \n', '*/ \n', 'contract Ownable {\n', '    address public owner;\n', '\n', '/** \n', '* @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '* account.\n', '*/\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '}\n', '\n', '\n', '/**\n', '* @title ERC20Basic\n', '* @dev Simpler version of ERC20 interface\n', '* @dev see https://github.com/ethereum/EIPs/issues/179\n', '*/\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public constant returns  (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', '* @title Basic token\n', '* @dev Basic version of StandardToken, with no allowances. \n', '*/\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of. \n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '}\n', '\n', '\n', '    /**\n', '    * @title ERC20 interface\n', '    * @dev see https://github.com/ethereum/EIPs/issues/20\n', '    */\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public constant returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', '* @title Standard ERC20 token\n', '*\n', '* @dev Implementation of the basic standard token.\n', '* @dev https://github.com/ethereum/EIPs/issues/20\n', '* @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', '*/\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    /**\n', '    * @dev Transfer tokens from one address to another\n', '    * @param _from address The address which you want to send tokens from\n', '    * @param _to address The address which you want to transfer to\n', '    * @param _value uint256 the amout of tokens to be transfered\n', '    */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '        balances[_to] = balances[_to].add(_value);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }       \n', '\n', '    /**\n', '    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _value The amount of tokens to be spent.\n', '    */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '    * @param _owner address The address which owns the funds.\n', '    * @param _spender address The address which will spend the funds.\n', '    * @return A uint256 specifing the amount of tokens still avaible for the spender.\n', '    */\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '}\n', '\n', '\n', '/*Token  Contract*/\n', 'contract ZXCToken is StandardToken, Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    // Token Information\n', '    string  public constant name = "MK7 Coin";\n', '    string  public constant symbol = "MK7";\n', '    uint8   public constant decimals = 18;\n', '\n', '    // Sale period1.\n', '    uint256 public startDate1;\n', '    uint256 public endDate1;\n', '\n', '    // Sale period2.\n', '    uint256 public startDate2;\n', '    uint256 public endDate2;\n', '\n', '    //SaleCap\n', '    uint256 public saleCap;\n', '\n', '    // Address Where Token are keep\n', '    address public tokenWallet;\n', '\n', '    // Address where funds are collected.\n', '    address public fundWallet;\n', '\n', '    // Amount of raised money in wei.\n', '    uint256 public weiRaised;\n', '\n', '    // Event\n', '    event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);\n', '    event PreICOTokenPushed(address indexed buyer, uint256 amount);\n', '\n', '    // Modifiers\n', '    modifier uninitialized() {\n', '        require(tokenWallet == 0x0);\n', '        require(fundWallet == 0x0);\n', '        _;\n', '    }\n', '\n', '    constructor() public {}\n', '    // Trigger with Transfer event\n', '    // Fallback function can be used to buy tokens\n', '    function () public payable {\n', '        buyTokens(msg.sender, msg.value);\n', '    }\n', '\n', '    //Initial Contract\n', '    function initialize(address _tokenWallet, address _fundWallet, uint256 _start1, uint256 _end1,\n', '                        uint256 _saleCap, uint256 _totalSupply) public\n', '                        onlyOwner uninitialized {\n', '        require(_start1 < _end1);\n', '        require(_tokenWallet != 0x0);\n', '        require(_fundWallet != 0x0);\n', '        require(_totalSupply >= _saleCap);\n', '\n', '        startDate1 = _start1;\n', '        endDate1 = _end1;\n', '        saleCap = _saleCap;\n', '        tokenWallet = _tokenWallet;\n', '        fundWallet = _fundWallet;\n', '        totalSupply = _totalSupply;\n', '\n', '        balances[tokenWallet] = saleCap;\n', '        balances[0xb1] = _totalSupply.sub(saleCap);\n', '    }\n', '\n', '    //Set PreSale Time\n', '    function setPeriod(uint period, uint256 _start, uint256 _end) public onlyOwner {\n', '        require(_end > _start);\n', '        if (period == 1) {\n', '            startDate1 = _start;\n', '            endDate1 = _end;\n', '        }else if (period == 2) {\n', '            require(_start > endDate1);\n', '            startDate2 = _start;\n', '            endDate2 = _end;      \n', '        }\n', '    }\n', '\n', '    // For pushing pre-ICO records\n', '    function sendForPreICO(address buyer, uint256 amount) public onlyOwner {\n', '        require(saleCap >= amount);\n', '\n', '        saleCap = saleCap - amount;\n', '        // Transfer\n', '        balances[tokenWallet] = balances[tokenWallet].sub(amount);\n', '        balances[buyer] = balances[buyer].add(amount);\n', '        emit PreICOTokenPushed(buyer, amount);\n', '        emit Transfer(tokenWallet, buyer, amount);\n', '    }\n', '\n', '    //Set SaleCap\n', '    function setSaleCap(uint256 _saleCap) public onlyOwner {\n', '        require(balances[0xb1].add(balances[tokenWallet]).sub(_saleCap) > 0);\n', '        uint256 amount=0;\n', '        //Check SaleCap\n', '        if (balances[tokenWallet] > _saleCap) {\n', '            amount = balances[tokenWallet].sub(_saleCap);\n', '            balances[0xb1] = balances[0xb1].add(amount);\n', '        } else {\n', '            amount = _saleCap.sub(balances[tokenWallet]);\n', '            balances[0xb1] = balances[0xb1].sub(amount);\n', '        }\n', '        balances[tokenWallet] = _saleCap;\n', '        saleCap = _saleCap;\n', '    }\n', '\n', '    //Calcute Bouns\n', '    function getBonusByTime(uint256 atTime) public constant returns (uint256) {\n', '        if (atTime < startDate1) {\n', '            return 0;\n', '        } else if (endDate1 > atTime && atTime > startDate1) {\n', '            return 5000;\n', '        } else if (endDate2 > atTime && atTime > startDate2) {\n', '            return 2500;\n', '        } else {\n', '            return 0;\n', '        }\n', '    }\n', '\n', '    function getBounsByAmount(uint256 etherAmount, uint256 tokenAmount) public pure returns (uint256) {\n', '        //Max 40%\n', '        uint256 bonusRatio = etherAmount.div(500 ether);\n', '        if (bonusRatio > 4) {\n', '            bonusRatio = 4;\n', '        }\n', '        uint256 bonusCount = SafeMath.mul(bonusRatio, 10);\n', '        uint256 bouns = SafeMath.mul(tokenAmount, bonusCount);\n', '        uint256 realBouns = SafeMath.div(bouns, 100);\n', '        return realBouns;\n', '    }\n', '\n', '    //Stop Contract\n', '    function finalize() public onlyOwner {\n', '        require(!saleActive());\n', '\n', '        // Transfer the rest of token to tokenWallet\n', '        balances[tokenWallet] = balances[tokenWallet].add(balances[0xb1]);\n', '        balances[0xb1] = 0;\n', '    }\n', '    \n', '    //Check SaleActive\n', '    function saleActive() public constant returns (bool) {\n', '        return (\n', '            (getCurrentTimestamp() >= startDate1 &&\n', '                getCurrentTimestamp() < endDate1 && saleCap > 0) ||\n', '            (getCurrentTimestamp() >= startDate2 &&\n', '                getCurrentTimestamp() < endDate2 && saleCap > 0)\n', '                );\n', '    }\n', '   \n', '    //Get CurrentTS\n', '    function getCurrentTimestamp() internal view returns (uint256) {\n', '        return now;\n', '    }\n', '\n', '     //Buy Token\n', '    function buyTokens(address sender, uint256 value) internal {\n', '        //Check Sale Status\n', '        require(saleActive());\n', '        \n', '        //Minum buying limit\n', '        require(value >= 0.5 ether);\n', '\n', '        // Calculate token amount to be purchased\n', '        uint256 bonus = getBonusByTime(getCurrentTimestamp());\n', '        uint256 amount = value.mul(bonus);\n', '        // If ETH > 500 the add 10%\n', '        if (getCurrentTimestamp() >= startDate1 && getCurrentTimestamp() < endDate1) {\n', '            uint256 p1Bouns = getBounsByAmount(value, amount);\n', '            amount = amount + p1Bouns;\n', '        }\n', '        // We have enough token to sale\n', '        require(saleCap >= amount);\n', '\n', '        // Transfer\n', '        balances[tokenWallet] = balances[tokenWallet].sub(amount);\n', '        balances[sender] = balances[sender].add(amount);\n', '        emit TokenPurchase(sender, value, amount);\n', '        emit Transfer(tokenWallet, sender, amount);\n', '        \n', '        saleCap = saleCap - amount;\n', '\n', '        // Update state.\n', '        weiRaised = weiRaised + value;\n', '\n', '        // Forward the fund to fund collection wallet.\n', '        fundWallet.transfer(msg.value);\n', '    }   \n', '}']
