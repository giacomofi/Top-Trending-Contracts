['pragma solidity ^0.4.15;\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', 'contract DYLC_ERC20Token {\n', '\n', '    address public owner;\n', '    string public name = "YLCHINA";\n', '    string public symbol = "DYLC";\n', '    uint8 public decimals = 18;\n', '\n', '    uint256 public totalSupply = 5000000000 * (10**18);\n', '    uint256 public currentSupply = 0;\n', '\n', '    uint256 public angelTime = 1522395000;\n', '    uint256 public privateTime = 1523777400;\n', '    uint256 public firstTime = 1525073400;\n', '    uint256 public secondTime = 1526369400;\n', '    uint256 public thirdTime = 1527665400;\n', '    uint256 public endTime = 1529047800;\n', '\n', '    uint256 public constant earlyExchangeRate = 83054;  \n', '    uint256 public constant baseExchangeRate = 55369; \n', '    \n', '    uint8 public constant rewardAngel = 20;\n', '    uint8 public constant rewardPrivate = 20;\n', '    uint8 public constant rewardOne = 15;\n', '    uint8 public constant rewardTwo = 10;\n', '    uint8 public constant rewardThree = 5;\n', '\n', '    uint256 public constant CROWD_SUPPLY = 550000000 * (10**18);\n', '    uint256 public constant DEVELOPER_RESERVED = 4450000000 * (10**18);\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    //event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    event Burn(address indexed from, uint256 value);\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    modifier onlyOwner() {\n', '      require(msg.sender == owner);\n', '      _;\n', '    }\n', '\n', '    function DYLC_ERC20Token() public {\n', '        owner = 0xA9802C071dD0D9fC470A06a487a2DB3D938a7b02;\n', '        balanceOf[owner] = DEVELOPER_RESERVED;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '      require(newOwner != address(0));\n', '      OwnershipTransferred(owner, newOwner);\n', '      owner = newOwner;\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        //Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   \n', '        balanceOf[msg.sender] -= _value;            \n', '        totalSupply -= _value;                      \n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                \n', '        require(_value <= allowance[_from][msg.sender]);    \n', '        balanceOf[_from] -= _value;                         \n', '        allowance[_from][msg.sender] -= _value;             \n', '        totalSupply -= _value;                              \n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '    \n', '    function () payable public{\n', '          buyTokens(msg.sender);\n', '    }\n', '    \n', '    function buyTokens(address beneficiary) public payable {\n', '      require(beneficiary != 0x0);\n', '      require(validPurchase());\n', '\n', '      uint256 rRate = rewardRate();\n', '\n', '      uint256 weiAmount = msg.value;\n', '      balanceOf[beneficiary] += weiAmount * rRate;\n', '      currentSupply += balanceOf[beneficiary];\n', '      forwardFunds();           \n', '    }\n', '\n', '    function rewardRate() internal constant returns (uint256) {\n', '            require(validPurchase());\n', '            uint256 rate;\n', '            if (now >= angelTime && now < privateTime){\n', '              rate = earlyExchangeRate + earlyExchangeRate * rewardAngel / 100;\n', '            }else if(now >= privateTime && now < firstTime){\n', '              rate = baseExchangeRate + baseExchangeRate * rewardPrivate / 100;\n', '            }else if(now >= firstTime && now < secondTime){\n', '              rate = baseExchangeRate + baseExchangeRate * rewardOne / 100;\n', '            }else if(now >= secondTime && now < thirdTime){\n', '              rate = baseExchangeRate + baseExchangeRate * rewardTwo / 100;\n', '            }else if(now >= thirdTime && now < endTime){\n', '              rate = baseExchangeRate + baseExchangeRate * rewardThree / 100;\n', '            }\n', '            return rate;\n', '      }\n', '\n', '      function forwardFunds() internal {\n', '            owner.transfer(msg.value);\n', '      }\n', '\n', '      function validPurchase() internal constant returns (bool) {\n', '            bool nonZeroPurchase = msg.value != 0;\n', '            bool noEnd = !hasEnded();\n', '            bool noSoleout = !isSoleout();\n', '            return  nonZeroPurchase && noEnd && noSoleout;\n', '      }\n', '\n', '      function afterCrowdSale() public onlyOwner {\n', '        require( hasEnded() && !isSoleout());\n', '        balanceOf[owner] = balanceOf[owner] + CROWD_SUPPLY - currentSupply;\n', '        currentSupply = CROWD_SUPPLY;\n', '      }\n', '\n', '\n', '      function hasEnded() public constant returns (bool) {\n', '            return (now > endTime); \n', '      }\n', '\n', '      function isSoleout() public constant returns (bool) {\n', '        return (currentSupply >= CROWD_SUPPLY);\n', '      }\n', '}']
['pragma solidity ^0.4.15;\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', 'contract DYLC_ERC20Token {\n', '\n', '    address public owner;\n', '    string public name = "YLCHINA";\n', '    string public symbol = "DYLC";\n', '    uint8 public decimals = 18;\n', '\n', '    uint256 public totalSupply = 5000000000 * (10**18);\n', '    uint256 public currentSupply = 0;\n', '\n', '    uint256 public angelTime = 1522395000;\n', '    uint256 public privateTime = 1523777400;\n', '    uint256 public firstTime = 1525073400;\n', '    uint256 public secondTime = 1526369400;\n', '    uint256 public thirdTime = 1527665400;\n', '    uint256 public endTime = 1529047800;\n', '\n', '    uint256 public constant earlyExchangeRate = 83054;  \n', '    uint256 public constant baseExchangeRate = 55369; \n', '    \n', '    uint8 public constant rewardAngel = 20;\n', '    uint8 public constant rewardPrivate = 20;\n', '    uint8 public constant rewardOne = 15;\n', '    uint8 public constant rewardTwo = 10;\n', '    uint8 public constant rewardThree = 5;\n', '\n', '    uint256 public constant CROWD_SUPPLY = 550000000 * (10**18);\n', '    uint256 public constant DEVELOPER_RESERVED = 4450000000 * (10**18);\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    //event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    event Burn(address indexed from, uint256 value);\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    modifier onlyOwner() {\n', '      require(msg.sender == owner);\n', '      _;\n', '    }\n', '\n', '    function DYLC_ERC20Token() public {\n', '        owner = 0xA9802C071dD0D9fC470A06a487a2DB3D938a7b02;\n', '        balanceOf[owner] = DEVELOPER_RESERVED;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '      require(newOwner != address(0));\n', '      OwnershipTransferred(owner, newOwner);\n', '      owner = newOwner;\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        //Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   \n', '        balanceOf[msg.sender] -= _value;            \n', '        totalSupply -= _value;                      \n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                \n', '        require(_value <= allowance[_from][msg.sender]);    \n', '        balanceOf[_from] -= _value;                         \n', '        allowance[_from][msg.sender] -= _value;             \n', '        totalSupply -= _value;                              \n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '    \n', '    function () payable public{\n', '          buyTokens(msg.sender);\n', '    }\n', '    \n', '    function buyTokens(address beneficiary) public payable {\n', '      require(beneficiary != 0x0);\n', '      require(validPurchase());\n', '\n', '      uint256 rRate = rewardRate();\n', '\n', '      uint256 weiAmount = msg.value;\n', '      balanceOf[beneficiary] += weiAmount * rRate;\n', '      currentSupply += balanceOf[beneficiary];\n', '      forwardFunds();           \n', '    }\n', '\n', '    function rewardRate() internal constant returns (uint256) {\n', '            require(validPurchase());\n', '            uint256 rate;\n', '            if (now >= angelTime && now < privateTime){\n', '              rate = earlyExchangeRate + earlyExchangeRate * rewardAngel / 100;\n', '            }else if(now >= privateTime && now < firstTime){\n', '              rate = baseExchangeRate + baseExchangeRate * rewardPrivate / 100;\n', '            }else if(now >= firstTime && now < secondTime){\n', '              rate = baseExchangeRate + baseExchangeRate * rewardOne / 100;\n', '            }else if(now >= secondTime && now < thirdTime){\n', '              rate = baseExchangeRate + baseExchangeRate * rewardTwo / 100;\n', '            }else if(now >= thirdTime && now < endTime){\n', '              rate = baseExchangeRate + baseExchangeRate * rewardThree / 100;\n', '            }\n', '            return rate;\n', '      }\n', '\n', '      function forwardFunds() internal {\n', '            owner.transfer(msg.value);\n', '      }\n', '\n', '      function validPurchase() internal constant returns (bool) {\n', '            bool nonZeroPurchase = msg.value != 0;\n', '            bool noEnd = !hasEnded();\n', '            bool noSoleout = !isSoleout();\n', '            return  nonZeroPurchase && noEnd && noSoleout;\n', '      }\n', '\n', '      function afterCrowdSale() public onlyOwner {\n', '        require( hasEnded() && !isSoleout());\n', '        balanceOf[owner] = balanceOf[owner] + CROWD_SUPPLY - currentSupply;\n', '        currentSupply = CROWD_SUPPLY;\n', '      }\n', '\n', '\n', '      function hasEnded() public constant returns (bool) {\n', '            return (now > endTime); \n', '      }\n', '\n', '      function isSoleout() public constant returns (bool) {\n', '        return (currentSupply >= CROWD_SUPPLY);\n', '      }\n', '}']
