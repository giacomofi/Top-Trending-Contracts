['pragma solidity ^0.4.21;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'interface ERC20 {\n', '    function balanceOf(address who) external view returns (uint256);\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract SafeCoin is ERC20 {\n', '    using SafeMath for uint;\n', '       \n', '    string internal _name;\n', '    string internal _symbol;\n', '    uint8 internal _decimals;\n', '    uint256 internal _totalSupply;\n', '\n', '    mapping (address => uint256) internal balances;\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    function SafeCoin() public {\n', '        _symbol = "SFC";\n', '        _name = "SafeCoin";\n', '        _decimals = 18;\n', '        _totalSupply = 500000000;\n', '        balances[msg.sender] = _totalSupply;\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {\n', '      require(_to != address(0));\n', '      require(_value <= balances[_from]);\n', '      balances[_from] = SafeMath.sub(balances[_from], _value);\n', '      balances[_to] = SafeMath.add(balances[_to], _value);\n', '      emit Transfer(_from, _to, _value);\n', '      return true;\n', '    }\n', '\n', '\n', '    function transfer(address _to, uint256 _value) external returns (bool) {\n', '      require(_to != address(0));\n', '      require(_value <= balances[msg.sender]);\n', '      balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);\n', '      balances[_to] = SafeMath.add(balances[_to], _value);\n', '      emit Transfer(msg.sender, _to, _value);\n', '      return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) external view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = SafeMath.sub(balances[_from], _value);\n', '        balances[_to] = SafeMath.add(balances[_to], _value);\n', '        allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) external returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) external view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '        allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '        allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', 'contract SafeBox is SafeCoin {\n', '    // ========================================================================================================\n', '    // ========================================================================================================\n', '    // FUNCTIONS RELATING TO THE MANAGEMENT OF THE CONTRACT ===================================================\n', '    mapping (address => user) private users;\n', '    user private user_object;\n', '    address private owner;\n', '    \n', '    struct Prices {\n', '        uint8 create;\n', '        uint8 edit;\n', '        uint8 active_contract;\n', '    }\n', '\n', '    Prices public prices;\n', '\n', '    function SafeBox() public {\n', '        owner = msg.sender;\n', '        prices.create = 10;\n', '        prices.edit = 10;\n', '        prices.active_contract = 10;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    // Muda o dono do contrato\n', '    function set_prices(uint8 _create, uint8 _edit, uint8 _active_contract) public onlyOwner returns (bool success){\n', '        prices.create = _create;\n', '        prices.edit = _edit;\n', '        prices.active_contract = _active_contract;\n', '        return true;\n', '    }\n', '\n', '    function _my_transfer(address _address, uint8 _price) private returns (bool) {\n', '        SafeCoin._transfer(_address, owner, _price);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ========================================================================================================\n', '    // ========================================================================================================\n', '    // FUNCOES RELATIVAS AO GERENCIAMENTO DE USUARIOS =========================================================\n', '    function set_status_user(address _address, bool _live_user, bool _active_contract) public onlyOwner returns (bool success) {\n', '        users[_address].live_user = _live_user;\n', '        users[_address].active_contract = _active_contract;\n', '        return true;\n', '    }\n', '\n', '    function set_active_contract() public returns (bool success) {\n', '        require(_my_transfer(msg.sender, prices.active_contract));\n', '        users[msg.sender].active_contract = true;\n', '        return true;\n', '    }\n', '\n', '    // PUBLIC TEMPORARIAMENTE, DEPOIS PRIVATE\n', '    function get_status_user(address _address) public view returns (\n', '            bool _live_user, bool _active_contract, bool _user_exists){\n', '        _live_user = users[_address].live_user;\n', '        _active_contract = users[_address].active_contract;\n', '        _user_exists = users[_address].exists;\n', '        return (_live_user, _active_contract, _user_exists);\n', '    }\n', '\n', '    // Criando objeto usuario\n', '    struct user {\n', '        bool exists;\n', '        address endereco;\n', '        bool live_user;\n', '        bool active_contract;\n', '    }\n', '\n', '    function _create_user(address _address) private {\n', '        /*\n', '            Fun&#231;&#227;o privada cria user\n', '        */\n', '        user_object = user(true, _address, true, true);\n', '        users[_address] = user_object;\n', '    }\n', '    \n', '    // ========================================================================================================\n', '    // ========================================================================================================\n', '    // FUN&#199;&#212;ES REFERENTES AOS COFRES ==========================================================================\n', '    struct Safe {\n', '        address safe_owner_address;\n', '        bool exists;\n', '        string safe_name;\n', '        address benefited_address;\n', '        string data;\n', '    }\n', '\n', '    Safe safe_object;\n', '    // Endereco titular + safe_name = ObjetoDados \n', '    mapping (address =>  mapping (string =>  Safe)) private map_data_safe_owner;\n', '    // Endereco benefited_address = ObjetoDados     \n', '    mapping (address =>  mapping (string =>  Safe)) private map_data_safe_benefited;\n', '\n', '    function create_safe(address _benef, string _data, string _safe_name) public returns (bool success) {\n', '        require(map_data_safe_owner[msg.sender][_safe_name].exists == false);\n', '        require(_my_transfer(msg.sender, prices.create));\n', '        if(users[msg.sender].exists == false){\n', '            _create_user(msg.sender);\n', '        }\n', '        // Transfere os tokens para o owner\n', '        // Cria um struct Safe\n', '        safe_object = Safe(msg.sender, true, _safe_name, _benef, _data);\n', '        // Salva o cofre no dicionario do titular\n', '        map_data_safe_owner[msg.sender][_safe_name] = safe_object;\n', '        // Salva o cofre no dicionario do beneficiado\n', '        map_data_safe_benefited[_benef][_safe_name] = safe_object;\n', '        return true;\n', '    }\n', '\n', '    function edit_safe(address _benef, string _new_data,\n', '                         string _safe_name) public returns (bool success) {\n', '        require(map_data_safe_owner[msg.sender][_safe_name].exists == true);\n', '        require(users[msg.sender].exists == true);\n', '        require(_my_transfer(msg.sender, prices.edit));\n', '        // _token.transferToOwner(msg.sender, owner, prices.edit, senha_owner);\n', '        // Salva o cofre no dicionario do titular\n', '        map_data_safe_owner[msg.sender][_safe_name].data = _new_data;\n', '        // Salva o cofre no dicionario do beneficiado\n', '        map_data_safe_benefited[_benef][_safe_name].data = _new_data;\n', '        return true;\n', '    }\n', '\n', '    //  Get infor do cofre beneficiado\n', '    function get_data_benefited(address _benef,\n', '            string _safe_name) public view returns (string) {\n', '        require(map_data_safe_benefited[_benef][_safe_name].exists == true);\n', '        address _safe_owner_address = map_data_safe_benefited[_benef][_safe_name].safe_owner_address;\n', '        require(users[_safe_owner_address].live_user == false);\n', '        require(users[_safe_owner_address].active_contract == true);\n', '        return map_data_safe_benefited[_benef][_safe_name].data;\n', '    }\n', '\n', '    //  Get infor do cofre beneficiado\n', '    function get_data_owner(address _address, string _safe_name)\n', '            public view returns (address _benefited_address, string _data) {\n', '        require(map_data_safe_owner[_address][_safe_name].exists == true);\n', '        require(users[_address].active_contract == true);\n', '        _benefited_address = map_data_safe_owner[_address][_safe_name].benefited_address;\n', '        _data = map_data_safe_owner[_address][_safe_name].data;\n', '        return (_benefited_address, _data);\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.21;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'interface ERC20 {\n', '    function balanceOf(address who) external view returns (uint256);\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract SafeCoin is ERC20 {\n', '    using SafeMath for uint;\n', '       \n', '    string internal _name;\n', '    string internal _symbol;\n', '    uint8 internal _decimals;\n', '    uint256 internal _totalSupply;\n', '\n', '    mapping (address => uint256) internal balances;\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    function SafeCoin() public {\n', '        _symbol = "SFC";\n', '        _name = "SafeCoin";\n', '        _decimals = 18;\n', '        _totalSupply = 500000000;\n', '        balances[msg.sender] = _totalSupply;\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {\n', '      require(_to != address(0));\n', '      require(_value <= balances[_from]);\n', '      balances[_from] = SafeMath.sub(balances[_from], _value);\n', '      balances[_to] = SafeMath.add(balances[_to], _value);\n', '      emit Transfer(_from, _to, _value);\n', '      return true;\n', '    }\n', '\n', '\n', '    function transfer(address _to, uint256 _value) external returns (bool) {\n', '      require(_to != address(0));\n', '      require(_value <= balances[msg.sender]);\n', '      balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);\n', '      balances[_to] = SafeMath.add(balances[_to], _value);\n', '      emit Transfer(msg.sender, _to, _value);\n', '      return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) external view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = SafeMath.sub(balances[_from], _value);\n', '        balances[_to] = SafeMath.add(balances[_to], _value);\n', '        allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) external returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) external view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '        allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '        allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', 'contract SafeBox is SafeCoin {\n', '    // ========================================================================================================\n', '    // ========================================================================================================\n', '    // FUNCTIONS RELATING TO THE MANAGEMENT OF THE CONTRACT ===================================================\n', '    mapping (address => user) private users;\n', '    user private user_object;\n', '    address private owner;\n', '    \n', '    struct Prices {\n', '        uint8 create;\n', '        uint8 edit;\n', '        uint8 active_contract;\n', '    }\n', '\n', '    Prices public prices;\n', '\n', '    function SafeBox() public {\n', '        owner = msg.sender;\n', '        prices.create = 10;\n', '        prices.edit = 10;\n', '        prices.active_contract = 10;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    // Muda o dono do contrato\n', '    function set_prices(uint8 _create, uint8 _edit, uint8 _active_contract) public onlyOwner returns (bool success){\n', '        prices.create = _create;\n', '        prices.edit = _edit;\n', '        prices.active_contract = _active_contract;\n', '        return true;\n', '    }\n', '\n', '    function _my_transfer(address _address, uint8 _price) private returns (bool) {\n', '        SafeCoin._transfer(_address, owner, _price);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ========================================================================================================\n', '    // ========================================================================================================\n', '    // FUNCOES RELATIVAS AO GERENCIAMENTO DE USUARIOS =========================================================\n', '    function set_status_user(address _address, bool _live_user, bool _active_contract) public onlyOwner returns (bool success) {\n', '        users[_address].live_user = _live_user;\n', '        users[_address].active_contract = _active_contract;\n', '        return true;\n', '    }\n', '\n', '    function set_active_contract() public returns (bool success) {\n', '        require(_my_transfer(msg.sender, prices.active_contract));\n', '        users[msg.sender].active_contract = true;\n', '        return true;\n', '    }\n', '\n', '    // PUBLIC TEMPORARIAMENTE, DEPOIS PRIVATE\n', '    function get_status_user(address _address) public view returns (\n', '            bool _live_user, bool _active_contract, bool _user_exists){\n', '        _live_user = users[_address].live_user;\n', '        _active_contract = users[_address].active_contract;\n', '        _user_exists = users[_address].exists;\n', '        return (_live_user, _active_contract, _user_exists);\n', '    }\n', '\n', '    // Criando objeto usuario\n', '    struct user {\n', '        bool exists;\n', '        address endereco;\n', '        bool live_user;\n', '        bool active_contract;\n', '    }\n', '\n', '    function _create_user(address _address) private {\n', '        /*\n', '            Função privada cria user\n', '        */\n', '        user_object = user(true, _address, true, true);\n', '        users[_address] = user_object;\n', '    }\n', '    \n', '    // ========================================================================================================\n', '    // ========================================================================================================\n', '    // FUNÇÔES REFERENTES AOS COFRES ==========================================================================\n', '    struct Safe {\n', '        address safe_owner_address;\n', '        bool exists;\n', '        string safe_name;\n', '        address benefited_address;\n', '        string data;\n', '    }\n', '\n', '    Safe safe_object;\n', '    // Endereco titular + safe_name = ObjetoDados \n', '    mapping (address =>  mapping (string =>  Safe)) private map_data_safe_owner;\n', '    // Endereco benefited_address = ObjetoDados     \n', '    mapping (address =>  mapping (string =>  Safe)) private map_data_safe_benefited;\n', '\n', '    function create_safe(address _benef, string _data, string _safe_name) public returns (bool success) {\n', '        require(map_data_safe_owner[msg.sender][_safe_name].exists == false);\n', '        require(_my_transfer(msg.sender, prices.create));\n', '        if(users[msg.sender].exists == false){\n', '            _create_user(msg.sender);\n', '        }\n', '        // Transfere os tokens para o owner\n', '        // Cria um struct Safe\n', '        safe_object = Safe(msg.sender, true, _safe_name, _benef, _data);\n', '        // Salva o cofre no dicionario do titular\n', '        map_data_safe_owner[msg.sender][_safe_name] = safe_object;\n', '        // Salva o cofre no dicionario do beneficiado\n', '        map_data_safe_benefited[_benef][_safe_name] = safe_object;\n', '        return true;\n', '    }\n', '\n', '    function edit_safe(address _benef, string _new_data,\n', '                         string _safe_name) public returns (bool success) {\n', '        require(map_data_safe_owner[msg.sender][_safe_name].exists == true);\n', '        require(users[msg.sender].exists == true);\n', '        require(_my_transfer(msg.sender, prices.edit));\n', '        // _token.transferToOwner(msg.sender, owner, prices.edit, senha_owner);\n', '        // Salva o cofre no dicionario do titular\n', '        map_data_safe_owner[msg.sender][_safe_name].data = _new_data;\n', '        // Salva o cofre no dicionario do beneficiado\n', '        map_data_safe_benefited[_benef][_safe_name].data = _new_data;\n', '        return true;\n', '    }\n', '\n', '    //  Get infor do cofre beneficiado\n', '    function get_data_benefited(address _benef,\n', '            string _safe_name) public view returns (string) {\n', '        require(map_data_safe_benefited[_benef][_safe_name].exists == true);\n', '        address _safe_owner_address = map_data_safe_benefited[_benef][_safe_name].safe_owner_address;\n', '        require(users[_safe_owner_address].live_user == false);\n', '        require(users[_safe_owner_address].active_contract == true);\n', '        return map_data_safe_benefited[_benef][_safe_name].data;\n', '    }\n', '\n', '    //  Get infor do cofre beneficiado\n', '    function get_data_owner(address _address, string _safe_name)\n', '            public view returns (address _benefited_address, string _data) {\n', '        require(map_data_safe_owner[_address][_safe_name].exists == true);\n', '        require(users[_address].active_contract == true);\n', '        _benefited_address = map_data_safe_owner[_address][_safe_name].benefited_address;\n', '        _data = map_data_safe_owner[_address][_safe_name].data;\n', '        return (_benefited_address, _data);\n', '    }\n', '\n', '}']
