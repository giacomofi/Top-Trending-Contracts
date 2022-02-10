['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-25\n', '*/\n', '\n', '// SPDX-License-Identifier: UNLICENSED\n', 'pragma solidity ^0.5.5;\n', '/*Math operations with safety checks */\n', 'contract SafeMath { \n', '  function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;  \n', '    }\n', '  function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {  \n', '    return a/b;  \n', '    }\n', '  function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;  \n', '    }\n', '  function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;  \n', '    }  \n', '  function safePower(uint a, uint b) internal pure returns (uint256) {\n', '      uint256 c = a**b;\n', '      return c;  \n', '    }\n', '}\n', '\n', 'interface IToken {\n', '  function transfer(address _to, uint256 _value) external;\n', '}\n', '\n', 'contract ZebiToken is SafeMath{\n', '    string public name;    \n', '    string public symbol;    \n', '    uint8   public decimals;    \n', '    uint256 public totalSupply;  \n', '    address payable public owner;\n', '    uint256 public totalSupplyLimit;\n', '    bool    public pauseMint;\n', '    address public minter;\n', '    address payable public ownerTemp;\n', '    uint256 blocknumberLastAcceptOwner;\n', '    uint256 blocknumberLastAcceptMinter;\n', '    address public minterTemp;\n', '    \n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '    mapping (address => bool) public blacklist;\n', '    \n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Burn(address indexed from, uint256 value);  \n', '    event Approval(address indexed owner, address indexed spender, uint256 value);  \n', '    event SetPauseMint(bool pause);\n', '    event SetOwner(address user);\n', '    event SetTotalSupplyLimit(uint amount);\n', '    event SetMinter(address minter);\n', '    event SetBlacklist(address user,bool isBlacklist);\n', '    event AcceptOwner(address user);\n', '    event AcceptMinter(address user);\n', '    \n', '    constructor (/* Initializes contract with initial supply tokens to the creator of the contract */\n', '        uint256 initialSupply,string memory tokenName,string memory tokenSymbol) public{\n', '        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens\n', '        totalSupply = initialSupply;                        // Update total supply\n', '        name = tokenName;                                   // Set the name for display purposes\n', '        symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '        decimals = 18;                                      // Amount of decimals for display purposes\n', '        owner = msg.sender;\n', '        totalSupplyLimit = 21000000 * (10 ** uint256(decimals));           \n', '    }\n', '    \n', '    function transfer(address _to, uint256 _value) public  returns (bool success){/* Send coins */\n', '        require (_to != address(0x0) && !blacklist[msg.sender]);    // Prevent transfer to 0x0 address. Use burn() instead\n', '        require (_value >= 0) ;                                                                 \n', '        require (balanceOf[msg.sender] >= _value) ;           // Check if the sender has enough\n', '        require (safeAdd(balanceOf[_to] , _value) >= balanceOf[_to]) ; // Check for overflows\n', '        balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value); // Subtract from the sender\n', '        balanceOf[_to] = safeAdd(balanceOf[_to], _value);               // Add the same to the recipient\n', '        emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {/* Allow another contract to spend some tokens in your behalf */\n', '        allowance[msg.sender][_spender] = _value;   \n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;    \n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {/* A contract attempts to get the coins */\n', '        require (_to != address(0x0) && !blacklist[_from]) ;                                // Prevent transfer to 0x0 address. Use burn() instead\n', '        require (_value >= 0) ;                                                 \n', '        require (balanceOf[_from] >= _value) ;                 // Check if the sender has enough\n', '        require (safeAdd(balanceOf[_to] , _value) >= balanceOf[_to]) ;  // Check for overflows\n', '        require (_value <= allowance[_from][msg.sender]) ;     // Check allowance\n', '        balanceOf[_from] = safeSub(balanceOf[_from], _value);                           // Subtract from the sender\n', '        balanceOf[_to] = safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient\n', '        allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true; \n', '      }\n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require (balanceOf[msg.sender] >= _value) ;            // Check if the sender has enough\n', '        require (_value > 0) ; \n', '        balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);            // Subtract from the sender\n', '        totalSupply = safeSub(totalSupply,_value);                                // Updates totalSupply\n', '        emit Burn(msg.sender, _value);          \n', '        emit Transfer(msg.sender, address(0), _value);\n', '        return true;\n', '    } \n', '    \n', '    function mintToken(uint256 _mintedAmount) public returns (bool success) {\n', '        require(msg.sender == minter && !pauseMint && safeAdd(totalSupply,_mintedAmount) <= totalSupplyLimit);\n', '        balanceOf[msg.sender] = safeAdd(balanceOf[msg.sender],_mintedAmount);\n', '        totalSupply = safeAdd(totalSupply,_mintedAmount);\n', '        emit Transfer(address(0x0), msg.sender, _mintedAmount);\n', '        return true;\n', '    }  \n', '\n', '    function setPauseMint(bool _pause) public{   \n', '        require (msg.sender == owner) ; \n', '        pauseMint = _pause;\n', '        emit SetPauseMint(_pause);\n', '    } \n', '    \n', '    function setMinter(address _minter) public{   \n', '        require (msg.sender == owner) ; \n', '        minterTemp = _minter;\n', '        blocknumberLastAcceptMinter = block.number + 42000;\n', '        emit SetMinter(_minter);\n', '    } \n', '    \n', '    function acceptMinter() public{   \n', '        require (msg.sender == owner  && block.number < blocknumberLastAcceptMinter && block.number > blocknumberLastAcceptMinter - 36000) ; \n', '        minter = minterTemp;\n', '        emit AcceptMinter(minterTemp);\n', '    } \n', '    \n', '    function setBlacklist(address _user,bool _isBlacklist) public{   \n', '        require (msg.sender == owner) ; \n', '        blacklist[_user] = _isBlacklist;\n', '        emit SetBlacklist(_user,_isBlacklist);\n', '    } \n', '\n', '    function setOwner(address payable _add) public{\n', '        require (msg.sender == owner && _add != address(0x0)) ;\n', '        ownerTemp = _add ;   \n', '        blocknumberLastAcceptOwner = block.number + 42000;\n', '        emit SetOwner(_add);\n', '    }\n', '    \n', '    function acceptOwner()public{\n', '        require (msg.sender == ownerTemp && block.number < blocknumberLastAcceptOwner && block.number > blocknumberLastAcceptOwner - 36000) ;\n', '        owner = ownerTemp ;\n', '        emit AcceptOwner(owner);\n', '    }\n', '\n', '    function setTotalSupplyLimit(uint _amount) public{\n', '        require (msg.sender == owner && _amount > 0) ;\n', '        totalSupplyLimit = _amount ;  \n', '        emit SetTotalSupplyLimit(_amount);  \n', '    }\n', '    \n', '    function() external payable  {}/* can accept ether */\n', '    \n', '    // transfer balance to owner\n', '    function withdrawToken(address token, uint amount) public{\n', '      require(msg.sender == owner);\n', '      if (token == address(0x0)) \n', '        owner.transfer(amount); \n', '      else \n', '        IToken(token).transfer(owner, amount);\n', '    }\n', '}']