['/*\n', 'PDOne (P1) - Official Smart Contract\n', 'Kitpay Fintech \n', 'https://pd1sto.com\n', '*/\n', 'pragma solidity 0.4.19;\n', '\n', 'library SafeMath {\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '      \n', '        uint256 c = a / b;\n', '        \n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract ERC20 {\n', '\n', '    function totalSupply()public view returns (uint total_Supply);\n', '    function balanceOf(address who)public view returns (uint256);\n', '    function allowance(address owner, address spender)public view returns (uint);\n', '    function transferFrom(address from, address to, uint value)public returns (bool ok);\n', '    function approve(address spender, uint value)public returns (bool ok);\n', '    function transfer(address to, uint value)public returns (bool ok);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '\n', '}\n', '\n', 'contract FiatContract\n', '{\n', '    function USD(uint _id) public constant returns (uint256);\n', '}\n', '\n', '\n', 'contract PDOne is ERC20\n', '{ \n', '    using SafeMath for uint256;\n', '\n', '    FiatContract price = FiatContract(0x2CDe56E5c8235D6360CCbb0c57Ce248Ca9C80909); // MAINNET FIAT ADDRESS\n', '\n', '    // Name of the token\n', '    string public constant name = "PDOne";\n', '    // Symbol of token\n', '    string public constant symbol = "P1";\n', '    uint8 public constant decimals = 8;\n', '    uint public _totalsupply = 250000000 * (uint256(10) ** decimals); // 250 million P1\n', '    address public owner;\n', '    bool stopped = false;\n', '    uint256 public startdate;\n', '    uint256 ico_first;\n', '    uint256 ico_second;\n', '    uint256 ico_third;\n', '    uint256 ico_fourth;\n', '    address central_account;\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '    \n', '    enum Stages {\n', '        NOTSTARTED,\n', '        ICO,\n', '        PAUSED,\n', '        ENDED\n', '    }\n', '\n', '    Stages public stage;\n', '    \n', '    modifier atStage(Stages _stage) {\n', '        if (stage != _stage)\n', '            // Contract not in expected state\n', '            revert();\n', '        _;\n', '    }\n', '    \n', '    modifier onlyOwner() {\n', '        if (msg.sender != owner) {\n', '            revert();\n', '        }\n', '        _;\n', '    }\n', '\n', '    modifier onlycentralAccount {\n', '        require(msg.sender == central_account);\n', '        _;\n', '    }\n', '\n', '    function PDOne() public\n', '    {\n', '        owner = msg.sender;\n', '        balances[owner] = 70000000 * (uint256(10) ** decimals);\n', '        balances[address(this)] = 180000000 * (uint256(10) ** decimals);\n', '        stage = Stages.NOTSTARTED;\n', '        Transfer(0, owner, balances[owner]);\n', '        Transfer(0, address(this), balances[address(this)]);\n', '    }\n', '    \n', '    function () public payable atStage(Stages.ICO)\n', '    {\n', '        require(msg.value >= 1 finney); //for round up and security measures\n', '        require(!stopped && msg.sender != owner);\n', '\n', '        uint256 ethCent = price.USD(0); //one USD cent in wei\n', '        uint256 tokPrice = ethCent.mul(80); //1P1 = 80 USD cent\n', '        \n', '        tokPrice = tokPrice.div(10 ** 8); //limit to 10 places\n', '        uint256 no_of_tokens = msg.value.div(tokPrice);\n', '        \n', '        uint256 bonus_token = 0;\n', '        \n', '        // Determine the bonus based on the time and the purchased amount\n', '        if (now < ico_first)\n', '        {\n', '            if (no_of_tokens >=  2000 * (uint256(10)**decimals) &&\n', '                no_of_tokens <= 19999 * (uint256(10)**decimals))\n', '            {\n', '                bonus_token = no_of_tokens.mul(20).div(100); \n', '            }\n', '            else if (no_of_tokens >   19999 * (uint256(10)**decimals) &&\n', '                     no_of_tokens <= 149999 * (uint256(10)**decimals))\n', '            {\n', '                bonus_token = no_of_tokens.mul(20).div(100); \n', '            }\n', '            else if (no_of_tokens > 149999 * (uint256(10)**decimals))\n', '            {\n', '                bonus_token = no_of_tokens.mul(20).div(100); \n', '            }\n', '            else\n', '            {\n', '                bonus_token = no_of_tokens.mul(20).div(100); \n', '            }\n', '        }\n', '        else if (now >= ico_first && now < ico_second)\n', '        {\n', '            if (no_of_tokens >=  2000 * (uint256(10)**decimals) &&\n', '                no_of_tokens <= 19999 * (uint256(10)**decimals))\n', '            {\n', '                bonus_token = no_of_tokens.mul(15).div(100); \n', '            }\n', '            else if (no_of_tokens >   19999 * (uint256(10)**decimals) &&\n', '                     no_of_tokens <= 149999 * (uint256(10)**decimals))\n', '            {\n', '                bonus_token = no_of_tokens.mul(15).div(100); \n', '            }\n', '            else if (no_of_tokens >  149999 * (uint256(10)**decimals))\n', '            {\n', '                bonus_token = no_of_tokens.mul(15).div(100); \n', '            }\n', '            else\n', '            {\n', '                bonus_token = no_of_tokens.mul(15).div(100); \n', '            }\n', '        }\n', '        else if (now >= ico_second && now < ico_third)\n', '        {\n', '            if (no_of_tokens >=  2000 * (uint256(10)**decimals) &&\n', '                no_of_tokens <= 19999 * (uint256(10)**decimals))\n', '            {\n', '                bonus_token = no_of_tokens.mul(10).div(100); \n', '            }\n', '            else if (no_of_tokens >   19999 * (uint256(10)**decimals) &&\n', '                     no_of_tokens <= 149999 * (uint256(10)**decimals))\n', '            {\n', '                bonus_token = no_of_tokens.mul(10).div(100); \n', '            }\n', '            else if (no_of_tokens >  149999 * (uint256(10)**decimals))\n', '            {\n', '                bonus_token = no_of_tokens.mul(10).div(100); \n', '            }\n', '            else\n', '            {\n', '                bonus_token = no_of_tokens.mul(10).div(100); //\n', '            }\n', '        }\n', '        else if (now >= ico_third && now < ico_fourth)\n', '        {\n', '            if (no_of_tokens >=  2000 * (uint256(10)**decimals) &&\n', '                no_of_tokens <= 19999 * (uint256(10)**decimals))\n', '            {\n', '                bonus_token = no_of_tokens.mul(10).div(100); \n', '            }\n', '            else if (no_of_tokens >   19999 * (uint256(10)**decimals) &&\n', '                     no_of_tokens <= 149999 * (uint256(10)**decimals))\n', '            {\n', '                bonus_token = no_of_tokens.mul(10).div(100); \n', '            }\n', '            else if (no_of_tokens >  149999 * (uint256(10)**decimals))\n', '            {\n', '                bonus_token = no_of_tokens.mul(10).div(100); \n', '            }\n', '            else\n', '            {\n', '                bonus_token = no_of_tokens.mul(10).div(100); \n', '            }\n', '        }\n', '        \n', '        uint256 total_token = no_of_tokens + bonus_token;\n', '        this.transfer(msg.sender, total_token);\n', '    }\n', '    \n', '    function start_ICO() public onlyOwner atStage(Stages.NOTSTARTED) {\n', '\n', '        stage = Stages.ICO;\n', '        stopped = false;\n', '        startdate = now;\n', '        ico_first = now + 9 days;\n', '        ico_second = ico_first + 21 days;\n', '        ico_third = ico_second + 15 days;\n', '        ico_fourth = ico_third + 14 days;\n', '    \n', '    }\n', '    \n', '    // called by the owner, pause ICO\n', '    function StopICO() external onlyOwner atStage(Stages.ICO) {\n', '    \n', '        stopped = true;\n', '        stage = Stages.PAUSED;\n', '    \n', '    }\n', '\n', '    // called by the owner , resumes ICO\n', '    function releaseICO() external onlyOwner atStage(Stages.PAUSED) {\n', '    \n', '        stopped = false;\n', '        stage = Stages.ICO;\n', '    \n', '    }\n', '    \n', '    function end_ICO() external onlyOwner atStage(Stages.ICO) {\n', '    \n', '        require(now > ico_fourth);\n', '        stage = Stages.ENDED;\n', '   \n', '    }\n', '    \n', '    function burn(uint256 _amount) external onlyOwner\n', '    {\n', '        require(_amount <= balances[address(this)]);\n', '        \n', '        _totalsupply = _totalsupply.sub(_amount);\n', '        balances[address(this)] = balances[address(this)].sub(_amount);\n', '        balances[0x0] = balances[0x0].add(_amount);\n', '        Transfer(address(this), 0x0, _amount);\n', '    }\n', '     \n', '    function set_centralAccount(address central_Acccount) external onlyOwner {\n', '    \n', '        central_account = central_Acccount;\n', '    \n', '    }\n', '\n', '\n', '\n', '    // what is the total supply of PDOne\n', '    function totalSupply() public view returns (uint256 total_Supply) {\n', '    \n', '        total_Supply = _totalsupply;\n', '    \n', '    }\n', '    \n', '    // What is the balance of a particular account?\n', '    function balanceOf(address _owner)public view returns (uint256 balance) {\n', '    \n', '        return balances[_owner];\n', '    \n', '    }\n', '    \n', '\n', '    function transferFrom( address _from, address _to, uint256 _amount )public returns (bool success) {\n', '    \n', '        require( _to != 0x0);\n', '    \n', '        balances[_from] = balances[_from].sub(_amount);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '    \n', '        Transfer(_from, _to, _amount);\n', '    \n', '        return true;\n', '    }\n', '    \n', '\n', '    function approve(address _spender, uint256 _amount)public returns (bool success) {\n', '        require(_amount == 0 || allowed[msg.sender][_spender] == 0);\n', '        require( _spender != 0x0);\n', '    \n', '        allowed[msg.sender][_spender] = _amount;\n', '    \n', '        Approval(msg.sender, _spender, _amount);\n', '    \n', '        return true;\n', '    }\n', '  \n', '    function allowance(address _owner, address _spender)public view returns (uint256 remaining) {\n', '    \n', '        require( _owner != 0x0 && _spender !=0x0);\n', '    \n', '        return allowed[_owner][_spender];\n', '   \n', '   }\n', '\n', '    function transfer(address _to, uint256 _amount)public returns (bool success) {\n', '    \n', '        require( _to != 0x0);\n', '        \n', '        balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '    \n', '        Transfer(msg.sender, _to, _amount);\n', '    \n', '        return true;\n', '    }\n', '    \n', '    function transferby(address _from,address _to,uint256 _amount) external onlycentralAccount returns(bool success) {\n', '    \n', '        require( _to != 0x0);\n', '        \n', '        require(_from == address(this));\n', '        \n', '        balances[_from] = (balances[_from]).sub(_amount);\n', '        balances[_to] = (balances[_to]).add(_amount);\n', '        if (_from == 0x0)\n', '        {\n', '            _totalsupply = _totalsupply.add(_amount);\n', '        }\n', '    \n', '        Transfer(_from, _to, _amount);\n', '    \n', '        return true;\n', '    }\n', '\n', '    function transferOwnership(address newOwner)public onlyOwner {\n', '\n', '        balances[newOwner] = balances[newOwner].add(balances[owner]);\n', '        balances[owner] = 0;\n', '        owner = newOwner;\n', '    \n', '    }\n', '\n', '    function drain() external onlyOwner {\n', '    \n', '        owner.transfer(this.balance);\n', '    \n', '    }\n', '    \n', '}']
['/*\n', 'PDOne (P1) - Official Smart Contract\n', 'Kitpay Fintech \n', 'https://pd1sto.com\n', '*/\n', 'pragma solidity 0.4.19;\n', '\n', 'library SafeMath {\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '      \n', '        uint256 c = a / b;\n', '        \n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract ERC20 {\n', '\n', '    function totalSupply()public view returns (uint total_Supply);\n', '    function balanceOf(address who)public view returns (uint256);\n', '    function allowance(address owner, address spender)public view returns (uint);\n', '    function transferFrom(address from, address to, uint value)public returns (bool ok);\n', '    function approve(address spender, uint value)public returns (bool ok);\n', '    function transfer(address to, uint value)public returns (bool ok);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '\n', '}\n', '\n', 'contract FiatContract\n', '{\n', '    function USD(uint _id) public constant returns (uint256);\n', '}\n', '\n', '\n', 'contract PDOne is ERC20\n', '{ \n', '    using SafeMath for uint256;\n', '\n', '    FiatContract price = FiatContract(0x2CDe56E5c8235D6360CCbb0c57Ce248Ca9C80909); // MAINNET FIAT ADDRESS\n', '\n', '    // Name of the token\n', '    string public constant name = "PDOne";\n', '    // Symbol of token\n', '    string public constant symbol = "P1";\n', '    uint8 public constant decimals = 8;\n', '    uint public _totalsupply = 250000000 * (uint256(10) ** decimals); // 250 million P1\n', '    address public owner;\n', '    bool stopped = false;\n', '    uint256 public startdate;\n', '    uint256 ico_first;\n', '    uint256 ico_second;\n', '    uint256 ico_third;\n', '    uint256 ico_fourth;\n', '    address central_account;\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '    \n', '    enum Stages {\n', '        NOTSTARTED,\n', '        ICO,\n', '        PAUSED,\n', '        ENDED\n', '    }\n', '\n', '    Stages public stage;\n', '    \n', '    modifier atStage(Stages _stage) {\n', '        if (stage != _stage)\n', '            // Contract not in expected state\n', '            revert();\n', '        _;\n', '    }\n', '    \n', '    modifier onlyOwner() {\n', '        if (msg.sender != owner) {\n', '            revert();\n', '        }\n', '        _;\n', '    }\n', '\n', '    modifier onlycentralAccount {\n', '        require(msg.sender == central_account);\n', '        _;\n', '    }\n', '\n', '    function PDOne() public\n', '    {\n', '        owner = msg.sender;\n', '        balances[owner] = 70000000 * (uint256(10) ** decimals);\n', '        balances[address(this)] = 180000000 * (uint256(10) ** decimals);\n', '        stage = Stages.NOTSTARTED;\n', '        Transfer(0, owner, balances[owner]);\n', '        Transfer(0, address(this), balances[address(this)]);\n', '    }\n', '    \n', '    function () public payable atStage(Stages.ICO)\n', '    {\n', '        require(msg.value >= 1 finney); //for round up and security measures\n', '        require(!stopped && msg.sender != owner);\n', '\n', '        uint256 ethCent = price.USD(0); //one USD cent in wei\n', '        uint256 tokPrice = ethCent.mul(80); //1P1 = 80 USD cent\n', '        \n', '        tokPrice = tokPrice.div(10 ** 8); //limit to 10 places\n', '        uint256 no_of_tokens = msg.value.div(tokPrice);\n', '        \n', '        uint256 bonus_token = 0;\n', '        \n', '        // Determine the bonus based on the time and the purchased amount\n', '        if (now < ico_first)\n', '        {\n', '            if (no_of_tokens >=  2000 * (uint256(10)**decimals) &&\n', '                no_of_tokens <= 19999 * (uint256(10)**decimals))\n', '            {\n', '                bonus_token = no_of_tokens.mul(20).div(100); \n', '            }\n', '            else if (no_of_tokens >   19999 * (uint256(10)**decimals) &&\n', '                     no_of_tokens <= 149999 * (uint256(10)**decimals))\n', '            {\n', '                bonus_token = no_of_tokens.mul(20).div(100); \n', '            }\n', '            else if (no_of_tokens > 149999 * (uint256(10)**decimals))\n', '            {\n', '                bonus_token = no_of_tokens.mul(20).div(100); \n', '            }\n', '            else\n', '            {\n', '                bonus_token = no_of_tokens.mul(20).div(100); \n', '            }\n', '        }\n', '        else if (now >= ico_first && now < ico_second)\n', '        {\n', '            if (no_of_tokens >=  2000 * (uint256(10)**decimals) &&\n', '                no_of_tokens <= 19999 * (uint256(10)**decimals))\n', '            {\n', '                bonus_token = no_of_tokens.mul(15).div(100); \n', '            }\n', '            else if (no_of_tokens >   19999 * (uint256(10)**decimals) &&\n', '                     no_of_tokens <= 149999 * (uint256(10)**decimals))\n', '            {\n', '                bonus_token = no_of_tokens.mul(15).div(100); \n', '            }\n', '            else if (no_of_tokens >  149999 * (uint256(10)**decimals))\n', '            {\n', '                bonus_token = no_of_tokens.mul(15).div(100); \n', '            }\n', '            else\n', '            {\n', '                bonus_token = no_of_tokens.mul(15).div(100); \n', '            }\n', '        }\n', '        else if (now >= ico_second && now < ico_third)\n', '        {\n', '            if (no_of_tokens >=  2000 * (uint256(10)**decimals) &&\n', '                no_of_tokens <= 19999 * (uint256(10)**decimals))\n', '            {\n', '                bonus_token = no_of_tokens.mul(10).div(100); \n', '            }\n', '            else if (no_of_tokens >   19999 * (uint256(10)**decimals) &&\n', '                     no_of_tokens <= 149999 * (uint256(10)**decimals))\n', '            {\n', '                bonus_token = no_of_tokens.mul(10).div(100); \n', '            }\n', '            else if (no_of_tokens >  149999 * (uint256(10)**decimals))\n', '            {\n', '                bonus_token = no_of_tokens.mul(10).div(100); \n', '            }\n', '            else\n', '            {\n', '                bonus_token = no_of_tokens.mul(10).div(100); //\n', '            }\n', '        }\n', '        else if (now >= ico_third && now < ico_fourth)\n', '        {\n', '            if (no_of_tokens >=  2000 * (uint256(10)**decimals) &&\n', '                no_of_tokens <= 19999 * (uint256(10)**decimals))\n', '            {\n', '                bonus_token = no_of_tokens.mul(10).div(100); \n', '            }\n', '            else if (no_of_tokens >   19999 * (uint256(10)**decimals) &&\n', '                     no_of_tokens <= 149999 * (uint256(10)**decimals))\n', '            {\n', '                bonus_token = no_of_tokens.mul(10).div(100); \n', '            }\n', '            else if (no_of_tokens >  149999 * (uint256(10)**decimals))\n', '            {\n', '                bonus_token = no_of_tokens.mul(10).div(100); \n', '            }\n', '            else\n', '            {\n', '                bonus_token = no_of_tokens.mul(10).div(100); \n', '            }\n', '        }\n', '        \n', '        uint256 total_token = no_of_tokens + bonus_token;\n', '        this.transfer(msg.sender, total_token);\n', '    }\n', '    \n', '    function start_ICO() public onlyOwner atStage(Stages.NOTSTARTED) {\n', '\n', '        stage = Stages.ICO;\n', '        stopped = false;\n', '        startdate = now;\n', '        ico_first = now + 9 days;\n', '        ico_second = ico_first + 21 days;\n', '        ico_third = ico_second + 15 days;\n', '        ico_fourth = ico_third + 14 days;\n', '    \n', '    }\n', '    \n', '    // called by the owner, pause ICO\n', '    function StopICO() external onlyOwner atStage(Stages.ICO) {\n', '    \n', '        stopped = true;\n', '        stage = Stages.PAUSED;\n', '    \n', '    }\n', '\n', '    // called by the owner , resumes ICO\n', '    function releaseICO() external onlyOwner atStage(Stages.PAUSED) {\n', '    \n', '        stopped = false;\n', '        stage = Stages.ICO;\n', '    \n', '    }\n', '    \n', '    function end_ICO() external onlyOwner atStage(Stages.ICO) {\n', '    \n', '        require(now > ico_fourth);\n', '        stage = Stages.ENDED;\n', '   \n', '    }\n', '    \n', '    function burn(uint256 _amount) external onlyOwner\n', '    {\n', '        require(_amount <= balances[address(this)]);\n', '        \n', '        _totalsupply = _totalsupply.sub(_amount);\n', '        balances[address(this)] = balances[address(this)].sub(_amount);\n', '        balances[0x0] = balances[0x0].add(_amount);\n', '        Transfer(address(this), 0x0, _amount);\n', '    }\n', '     \n', '    function set_centralAccount(address central_Acccount) external onlyOwner {\n', '    \n', '        central_account = central_Acccount;\n', '    \n', '    }\n', '\n', '\n', '\n', '    // what is the total supply of PDOne\n', '    function totalSupply() public view returns (uint256 total_Supply) {\n', '    \n', '        total_Supply = _totalsupply;\n', '    \n', '    }\n', '    \n', '    // What is the balance of a particular account?\n', '    function balanceOf(address _owner)public view returns (uint256 balance) {\n', '    \n', '        return balances[_owner];\n', '    \n', '    }\n', '    \n', '\n', '    function transferFrom( address _from, address _to, uint256 _amount )public returns (bool success) {\n', '    \n', '        require( _to != 0x0);\n', '    \n', '        balances[_from] = balances[_from].sub(_amount);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '    \n', '        Transfer(_from, _to, _amount);\n', '    \n', '        return true;\n', '    }\n', '    \n', '\n', '    function approve(address _spender, uint256 _amount)public returns (bool success) {\n', '        require(_amount == 0 || allowed[msg.sender][_spender] == 0);\n', '        require( _spender != 0x0);\n', '    \n', '        allowed[msg.sender][_spender] = _amount;\n', '    \n', '        Approval(msg.sender, _spender, _amount);\n', '    \n', '        return true;\n', '    }\n', '  \n', '    function allowance(address _owner, address _spender)public view returns (uint256 remaining) {\n', '    \n', '        require( _owner != 0x0 && _spender !=0x0);\n', '    \n', '        return allowed[_owner][_spender];\n', '   \n', '   }\n', '\n', '    function transfer(address _to, uint256 _amount)public returns (bool success) {\n', '    \n', '        require( _to != 0x0);\n', '        \n', '        balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '    \n', '        Transfer(msg.sender, _to, _amount);\n', '    \n', '        return true;\n', '    }\n', '    \n', '    function transferby(address _from,address _to,uint256 _amount) external onlycentralAccount returns(bool success) {\n', '    \n', '        require( _to != 0x0);\n', '        \n', '        require(_from == address(this));\n', '        \n', '        balances[_from] = (balances[_from]).sub(_amount);\n', '        balances[_to] = (balances[_to]).add(_amount);\n', '        if (_from == 0x0)\n', '        {\n', '            _totalsupply = _totalsupply.add(_amount);\n', '        }\n', '    \n', '        Transfer(_from, _to, _amount);\n', '    \n', '        return true;\n', '    }\n', '\n', '    function transferOwnership(address newOwner)public onlyOwner {\n', '\n', '        balances[newOwner] = balances[newOwner].add(balances[owner]);\n', '        balances[owner] = 0;\n', '        owner = newOwner;\n', '    \n', '    }\n', '\n', '    function drain() external onlyOwner {\n', '    \n', '        owner.transfer(this.balance);\n', '    \n', '    }\n', '    \n', '}']
