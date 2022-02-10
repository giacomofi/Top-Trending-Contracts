['pragma solidity ^0.4.23;\n', '\n', 'contract ERC20Interface {\n', '\n', '    uint256 public totalSupply;\n', '    uint256 public decimals;\n', '\t\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '\n', '    // solhint-disable-next-line no-simple-event-func-name  \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value); \n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '// C1\n', '\n', 'contract OwnableContract {\n', ' \n', '    address ContractCreator;\n', '\t\t\n', '\tconstructor() public { \n', '        ContractCreator = msg.sender;  \n', '    }\n', '\t\n', '\tmodifier onlyOwner() {\n', '        require(msg.sender == ContractCreator);\n', '        _;\n', '    } \n', '    \n', '    function ContractCreatorAddress() public view returns (address owner) {\n', '        return ContractCreator;\n', '    }\n', '    \n', '\tfunction O2_ChangeOwner(address NewOwner) onlyOwner public {\n', '        ContractCreator = NewOwner;\n', '    }\n', '}\n', '\n', '\n', '// C2\n', '\n', 'contract BlockableContract is OwnableContract{\n', ' \n', '    bool public blockedContract;\n', '\t\n', '\tconstructor() public { \n', '        blockedContract = false;  \n', '    }\n', '\t\n', '\tmodifier contractActive() {\n', '        require(!blockedContract);\n', '        _;\n', '    } \n', '\t\n', '\tfunction O3_BlockContract() onlyOwner public {\n', '        blockedContract = true;\n', '    }\n', '    \n', '    function O4_UnblockContract() onlyOwner public {\n', '        blockedContract = false;\n', '    }\n', '}\n', '\n', '// C3\n', '\n', 'contract Hodl is BlockableContract{\n', '    \n', '    struct Safe{\n', '        uint256 id;\n', '        address user;\n', '        address tokenAddress;\n', '        uint256 amount;\n', '        uint256 time;\n', '    }\n', '    \n', '    //dev safes variables\n', '   \n', '    mapping( address => uint256[]) private _member;\n', '    mapping( uint256 => Safe) private _safes;\n', '    uint256 private _currentIndex;\n', '    \n', '    mapping( address => uint256) public TotalBalances;\n', '     \n', '    //@dev owner variables\n', '\n', '    uint256 public comission; //0..100\n', '    mapping( address => uint256) private _Ethbalances;\n', '    address[] private _listedReserves;\n', '     \n', '    //constructor\n', '\n', '    constructor() public { \n', '        _currentIndex = 1;\n', '        comission = 10;\n', '    }\n', '    \n', '\t\n', '\t\n', '// F1 - fallback function to receive donation eth //\n', '    function () public payable {\n', '        require(msg.value>0);\n', '        _Ethbalances[0x0] = add(_Ethbalances[0x0], msg.value);\n', '    }\n', '\t\n', '\n', '\t\n', '// F2 - how many safes has the user //\n', '    function DepositCount(address a) public view returns (uint256 length) {\n', '        return _member[a].length;\n', '    }\n', '\t\n', '\n', '\t\n', '// F3 - how many tokens are reserved for owner as comission //\n', '    function OwnerTokenBalance(address tokenAddress) public view returns (uint256 amount){\n', '        return _Ethbalances[tokenAddress];\n', '    }\n', '\t\n', '\n', '\t\n', "// F4 - returns safe's values' //\n", '    function GetUserData(uint256 _id) public view\n', '        returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 time)\n', '    {\n', '        Safe storage s = _safes[_id];\n', '        return(s.id, s.user, s.tokenAddress, s.amount, s.time);\n', '    }\n', '\t\n', '\n', '\t\n', '// F5 - add new hodl safe (ETH) //\n', '    function U1_HodlEth(uint256 time) public contractActive payable {\n', '        require(msg.value > 0);\n', '        require(time>now);\n', '        \n', '        _member[msg.sender].push(_currentIndex);\n', '        _safes[_currentIndex] = Safe(_currentIndex, msg.sender, 0x0, msg.value, time); \n', '        \n', '        TotalBalances[0x0] = add(TotalBalances[0x0], msg.value);\n', '        \n', '        _currentIndex++;\n', '    }\n', '\t\n', '\n', '\t\n', '// F6 add new hodl safe (ERC20 token) //\n', '    \n', '    function U2_HodlERC20(address tokenAddress, uint256 amount, uint256 time) public contractActive {\n', '        require(tokenAddress != 0x0);\n', '        require(amount>0);\n', '        require(time>now);\n', '          \n', '        ERC20Interface token = ERC20Interface(tokenAddress);\n', '        require( token.transferFrom(msg.sender, address(this), amount) );\n', '        \n', '        _member[msg.sender].push(_currentIndex);\n', '        _safes[_currentIndex] = Safe(_currentIndex, msg.sender, tokenAddress, amount, time);\n', '        \n', '        TotalBalances[tokenAddress] = add(TotalBalances[tokenAddress], amount);\n', '        \n', '        _currentIndex++;\n', '    }\n', '\t\n', '\n', '\t\n', '// F7 - user, claim back a hodl safe //\n', '    function U3_UserRetireHodl(uint256 id) public {\n', '        Safe storage s = _safes[id];\n', '        \n', '        require(s.id != 0);\n', '        require(s.user == msg.sender);\n', '        \n', '        RetireHodl(id);\n', '    }\n', '\t\n', '\n', '\t\n', '// F8 - private retire hodl safe action //\n', '    function RetireHodl(uint256 id) private {\n', '        Safe storage s = _safes[id]; \n', '        require(s.id != 0); \n', '        \n', '        if(s.time < now) //hodl complete\n', '        {\n', '            if(s.tokenAddress == 0x0) \n', '                PayEth(s.user, s.amount);\n', '            else  \n', '                PayToken(s.user, s.tokenAddress, s.amount);\n', '        }\n', '        else //hodl in progress\n', '        {\n', '            uint256 realComission = mul(s.amount, comission) / 100;\n', '            uint256 realAmount = sub(s.amount, realComission);\n', '            \n', '            if(s.tokenAddress == 0x0) \n', '                PayEth(s.user, realAmount);\n', '            else  \n', '                PayToken(s.user, s.tokenAddress, realAmount);\n', '                \n', '            StoreComission(s.tokenAddress, realComission);\n', '        }\n', '        \n', '        DeleteSafe(s);\n', '    }\n', '\t\n', '\n', '\t\t\n', '// F9 - private pay eth to address //\n', '    function PayEth(address user, uint256 amount) private {\n', '        require(address(this).balance >= amount);\n', '        user.transfer(amount);\n', '    }\n', '\t\n', '\n', '\t\n', '// F10 - private pay token to address //\n', '    function PayToken(address user, address tokenAddress, uint256 amount) private{\n', '        ERC20Interface token = ERC20Interface(tokenAddress);\n', '        require(token.balanceOf(address(this)) >= amount);\n', '        token.transfer(user, amount);\n', '    }\n', '\t\n', '\n', '\t\n', '// F11 - store comission from unfinished hodl //\n', '    function StoreComission(address tokenAddress, uint256 amount) private {\n', '        _Ethbalances[tokenAddress] = add(_Ethbalances[tokenAddress], amount);\n', '        \n', '        bool isNew = true;\n', '        for(uint256 i = 0; i < _listedReserves.length; i++) {\n', '            if(_listedReserves[i] == tokenAddress) {\n', '                isNew = false;\n', '                break;\n', '            }\n', '        } \n', '        \n', '        if(isNew) _listedReserves.push(tokenAddress); \n', '    }\n', '\t\n', '\n', '\t\t\n', '// F12 - delete safe values in storage //\n', '    function DeleteSafe(Safe s) private  {\n', '        TotalBalances[s.tokenAddress] = sub(TotalBalances[s.tokenAddress], s.amount);\n', '        delete _safes[s.id];\n', '        \n', '        uint256[] storage vector = _member[msg.sender];\n', '        uint256 size = vector.length; \n', '        for(uint256 i = 0; i < size; i++) {\n', '            if(vector[i] == s.id) {\n', '                vector[i] = vector[size-1];\n', '                vector.length--;\n', '                break;\n', '            }\n', '        } \n', '    }\n', '\t\n', '\n', '\t\n', '// F13 // OWNER - owner retire hodl safe //\n', '    function O5_OwnerRetireHodl(uint256 id) public onlyOwner {\n', '        Safe storage s = _safes[id]; \n', '        require(s.id != 0); \n', '        RetireHodl(id);\n', '    }\n', '\t\n', '\n', '\t\n', '// F14 - owner, change comission value //\n', '    function O1_ChangeComission(uint256 newComission) onlyOwner public {\n', '        comission = newComission;\n', '    }\n', '\t\n', '\n', '\t\n', '// F15 - owner withdraw eth reserved from comissions //\n', '    function O6_WithdrawReserve(address tokenAddress) onlyOwner public\n', '    {\n', '        require(_Ethbalances[tokenAddress] > 0);\n', '        \n', '        uint256 amount = _Ethbalances[tokenAddress];\n', '        _Ethbalances[tokenAddress] = 0;\n', '        \n', '        ERC20Interface token = ERC20Interface(tokenAddress);\n', '        require(token.balanceOf(address(this)) >= amount);\n', '        token.transfer(msg.sender, amount);\n', '    }\n', '\t\n', '\n', '\t \n', '// F16 - owner withdraw token reserved from comission //\n', '    function O7_WithdrawAllReserves() onlyOwner public {\n', '        //eth\n', '        uint256 x = _Ethbalances[0x0];\n', '        if(x > 0 && x <= address(this).balance) {\n', '            _Ethbalances[0x0] = 0;\n', '            msg.sender.transfer( _Ethbalances[0x0] );\n', '        }\n', '         \n', '    //tokens\n', '        address ta;\n', '        ERC20Interface token;\n', '        for(uint256 i = 0; i < _listedReserves.length; i++) {\n', '            ta = _listedReserves[i];\n', '            if(_Ethbalances[ta] > 0)\n', '            { \n', '                x = _Ethbalances[ta];\n', '                _Ethbalances[ta] = 0;\n', '                \n', '                token = ERC20Interface(ta);\n', '                token.transfer(msg.sender, x);\n', '            }\n', '        } \n', '        \n', '        _listedReserves.length = 0; \n', '    }\n', '\t\n', '\n', '\t\n', '// F17 - owner remove free eth //\n', '    function O8_WithdrawSpecialEth(uint256 amount) onlyOwner public\n', '    {\n', '        require(amount > 0); \n', '        uint256 freeBalance = address(this).balance - TotalBalances[0x0];\n', '        require(freeBalance >= amount); \n', '        msg.sender.transfer(amount);\n', '    }\n', '\t\n', '\n', '\t\n', '// F18 - owner remove free token //\n', '    function O9_WithdrawSpecialToken(address tokenAddress, uint256 amount) onlyOwner public\n', '    {\n', '        ERC20Interface token = ERC20Interface(tokenAddress);\n', '        uint256 freeBalance = token.balanceOf(address(this)) - TotalBalances[tokenAddress];\n', '        require(freeBalance >= amount);\n', '        token.transfer(msg.sender, amount);\n', '    } \n', '\t\n', '\n', '\t  \n', '    //AUX - @dev Multiplies two numbers, throws on overflow. //\n', '    \n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '    \n', '    //dev Integer division of two numbers, truncating the quotient. //\n', '   \n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        // uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return a / b;\n', '    }\n', '    \n', '    // dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend). //\n', '  \n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '    \n', '    // @dev Adds two numbers, throws on overflow. //\n', '  \n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '    \n', '    \n', '}']