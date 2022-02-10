['pragma solidity ^0.4.8;\n', '/*\n', 'AvatarNetwork Copyright\n', '\n', 'https://avatarnetwork.io\n', '\n', '*/\n', '\n', '/* Родительский контракт */\n', 'contract Owned {\n', '\n', '    /* Адрес владельца контракта*/\n', '    address owner;\n', '\n', '    /* Конструктор контракта, вызывается при первом запуске */\n', '    function Owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '        /* Изменить владельца контракта, newOwner - адрес нового владельца */\n', '    function changeOwner(address newOwner) onlyowner {\n', '        owner = newOwner;\n', '    }\n', '\n', '\n', '    /* Модификатор для ограничения доступа к функциям только для владельца */\n', '    modifier onlyowner() {\n', '        if (msg.sender==owner) _;\n', '    }\n', '}\n', '\n', '// Абстрактный контракт для токена стандарта ERC 20\n', '// https://github.com/ethereum/EIPs/issues/20\n', 'contract Token is Owned {\n', '\n', '    /// Общее кол-во токенов\n', '    uint256 public totalSupply;\n', '\n', '    /// @param _owner адрес, с которого будет получен баланс\n', '    /// @return Баланс\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', '    /// @notice Отправить кол-во `_value` токенов на адрес `_to` с адреса `msg.sender`\n', '    /// @param _to Адрес получателя\n', '    /// @param _value Кол-во токенов для отправки\n', '    /// @return Была ли отправка успешной или нет\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice Отправить кол-во `_value` токенов на адрес `_to` с адреса `_from` при условии что это подтверждено отправителем `_from`\n', '    /// @param _from Адрес отправителя\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice Вызывающий функции `msg.sender` подтверждает что с адреса `_spender` спишется `_value` токенов\n', '    /// @param _spender Адрес аккаунта, с которого возможно списать токены\n', '    /// @param _value Кол-во токенов к подтверждению для отправки\n', '    /// @return Было ли подтверждение успешным или нет\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '\n', '    /// @param _owner Адрес аккаунта владеющего токенами\n', '    /// @param _spender Адрес аккаунта, с которого возможно списать токены\n', '    /// @return Кол-во оставшихся токенов разрешённых для отправки\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '/*\n', 'Контракт реализует ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20\n', '*/\n', 'contract ERC20Token is Token\n', '{\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success)\n', '    {\n', '        //По-умолчанию предполагается, что totalSupply не может быть больше (2^256 - 1).\n', '        if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success)\n', '    {\n', '        //По-умолчанию предполагается, что totalSupply не может быть больше (2^256 - 1).\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance)\n', '    {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success)\n', '    {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining)\n', '    {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', '/* Основной контракт токена, наследует ERC20Token */\n', 'contract ArmMoneyliFe is ERC20Token\n', '{\n', '    bool public isTokenSale = true;\n', '    uint256 public price;\n', '    uint256 public limit;\n', '\n', '    address walletOut = 0xde8c00ae50b203ac1091266d5b207fbc59be5bc4;\n', '\n', '    function getWalletOut() constant returns (address _to) {\n', '        return walletOut;\n', '    }\n', '\n', '    function () external payable  {\n', '        if (isTokenSale == false) {\n', '            throw;\n', '        }\n', '\n', '        uint256 tokenAmount = (msg.value  * 1000000000000000000) / price;\n', '\n', '        if (balances[owner] >= tokenAmount && balances[msg.sender] + tokenAmount > balances[msg.sender]) {\n', '            if (balances[owner] - tokenAmount < limit) {\n', '                throw;\n', '            }\n', '            balances[owner] -= tokenAmount;\n', '            balances[msg.sender] += tokenAmount;\n', '            Transfer(owner, msg.sender, tokenAmount);\n', '        } else {\n', '            throw;\n', '        }\n', '    }\n', '\n', '    function stopSale() onlyowner {\n', '        isTokenSale = false;\n', '    }\n', '\n', '    function startSale() onlyowner {\n', '        isTokenSale = true;\n', '    }\n', '\n', '    function setPrice(uint256 newPrice) onlyowner {\n', '        price = newPrice;\n', '    }\n', '\n', '    function setLimit(uint256 newLimit) onlyowner {\n', '        limit = newLimit;\n', '    }\n', '\n', '    function setWallet(address _to) onlyowner {\n', '        walletOut = _to;\n', '    }\n', '\n', '    function sendFund() onlyowner {\n', '        walletOut.send(this.balance);\n', '    }\n', '\n', '    /* Публичные переменные токена */\n', '    string public name;                 // Название\n', '    uint8 public decimals;              // Сколько десятичных знаков\n', '    string public symbol;               // Идентификатор (трехбуквенный обычно)\n', '    string public version = &#39;1.0&#39;;      // Версия\n', '\n', '    function ArmMoneyliFe()\n', '    {\n', '        totalSupply = 1000000000000000000000000000;\n', '        balances[msg.sender] = 1000000000000000000000000000;  // Передача создателю всех выпущенных монет\n', '        name = &#39;ArmMoneyliFe&#39;;\n', '        decimals = 18;\n', '        symbol = &#39;AMF&#39;;\n', '        price = 2188183807439824;\n', '        limit = 0;\n', '    }\n', '\n', '    \n', '    /* Добавляет на счет токенов */\n', '    function add(uint256 _value) onlyowner returns (bool success)\n', '    {\n', '        if (balances[msg.sender] + _value <= balances[msg.sender]) {\n', '            return false;\n', '        }\n', '        totalSupply += _value;\n', '        balances[msg.sender] += _value;\n', '        return true;\n', '    }\n', '\n', '\n', '    \n', '}']
['pragma solidity ^0.4.8;\n', '/*\n', 'AvatarNetwork Copyright\n', '\n', 'https://avatarnetwork.io\n', '\n', '*/\n', '\n', '/* Родительский контракт */\n', 'contract Owned {\n', '\n', '    /* Адрес владельца контракта*/\n', '    address owner;\n', '\n', '    /* Конструктор контракта, вызывается при первом запуске */\n', '    function Owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '        /* Изменить владельца контракта, newOwner - адрес нового владельца */\n', '    function changeOwner(address newOwner) onlyowner {\n', '        owner = newOwner;\n', '    }\n', '\n', '\n', '    /* Модификатор для ограничения доступа к функциям только для владельца */\n', '    modifier onlyowner() {\n', '        if (msg.sender==owner) _;\n', '    }\n', '}\n', '\n', '// Абстрактный контракт для токена стандарта ERC 20\n', '// https://github.com/ethereum/EIPs/issues/20\n', 'contract Token is Owned {\n', '\n', '    /// Общее кол-во токенов\n', '    uint256 public totalSupply;\n', '\n', '    /// @param _owner адрес, с которого будет получен баланс\n', '    /// @return Баланс\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', '    /// @notice Отправить кол-во `_value` токенов на адрес `_to` с адреса `msg.sender`\n', '    /// @param _to Адрес получателя\n', '    /// @param _value Кол-во токенов для отправки\n', '    /// @return Была ли отправка успешной или нет\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice Отправить кол-во `_value` токенов на адрес `_to` с адреса `_from` при условии что это подтверждено отправителем `_from`\n', '    /// @param _from Адрес отправителя\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice Вызывающий функции `msg.sender` подтверждает что с адреса `_spender` спишется `_value` токенов\n', '    /// @param _spender Адрес аккаунта, с которого возможно списать токены\n', '    /// @param _value Кол-во токенов к подтверждению для отправки\n', '    /// @return Было ли подтверждение успешным или нет\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '\n', '    /// @param _owner Адрес аккаунта владеющего токенами\n', '    /// @param _spender Адрес аккаунта, с которого возможно списать токены\n', '    /// @return Кол-во оставшихся токенов разрешённых для отправки\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '/*\n', 'Контракт реализует ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20\n', '*/\n', 'contract ERC20Token is Token\n', '{\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success)\n', '    {\n', '        //По-умолчанию предполагается, что totalSupply не может быть больше (2^256 - 1).\n', '        if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success)\n', '    {\n', '        //По-умолчанию предполагается, что totalSupply не может быть больше (2^256 - 1).\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance)\n', '    {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success)\n', '    {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining)\n', '    {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', '/* Основной контракт токена, наследует ERC20Token */\n', 'contract ArmMoneyliFe is ERC20Token\n', '{\n', '    bool public isTokenSale = true;\n', '    uint256 public price;\n', '    uint256 public limit;\n', '\n', '    address walletOut = 0xde8c00ae50b203ac1091266d5b207fbc59be5bc4;\n', '\n', '    function getWalletOut() constant returns (address _to) {\n', '        return walletOut;\n', '    }\n', '\n', '    function () external payable  {\n', '        if (isTokenSale == false) {\n', '            throw;\n', '        }\n', '\n', '        uint256 tokenAmount = (msg.value  * 1000000000000000000) / price;\n', '\n', '        if (balances[owner] >= tokenAmount && balances[msg.sender] + tokenAmount > balances[msg.sender]) {\n', '            if (balances[owner] - tokenAmount < limit) {\n', '                throw;\n', '            }\n', '            balances[owner] -= tokenAmount;\n', '            balances[msg.sender] += tokenAmount;\n', '            Transfer(owner, msg.sender, tokenAmount);\n', '        } else {\n', '            throw;\n', '        }\n', '    }\n', '\n', '    function stopSale() onlyowner {\n', '        isTokenSale = false;\n', '    }\n', '\n', '    function startSale() onlyowner {\n', '        isTokenSale = true;\n', '    }\n', '\n', '    function setPrice(uint256 newPrice) onlyowner {\n', '        price = newPrice;\n', '    }\n', '\n', '    function setLimit(uint256 newLimit) onlyowner {\n', '        limit = newLimit;\n', '    }\n', '\n', '    function setWallet(address _to) onlyowner {\n', '        walletOut = _to;\n', '    }\n', '\n', '    function sendFund() onlyowner {\n', '        walletOut.send(this.balance);\n', '    }\n', '\n', '    /* Публичные переменные токена */\n', '    string public name;                 // Название\n', '    uint8 public decimals;              // Сколько десятичных знаков\n', '    string public symbol;               // Идентификатор (трехбуквенный обычно)\n', "    string public version = '1.0';      // Версия\n", '\n', '    function ArmMoneyliFe()\n', '    {\n', '        totalSupply = 1000000000000000000000000000;\n', '        balances[msg.sender] = 1000000000000000000000000000;  // Передача создателю всех выпущенных монет\n', "        name = 'ArmMoneyliFe';\n", '        decimals = 18;\n', "        symbol = 'AMF';\n", '        price = 2188183807439824;\n', '        limit = 0;\n', '    }\n', '\n', '    \n', '    /* Добавляет на счет токенов */\n', '    function add(uint256 _value) onlyowner returns (bool success)\n', '    {\n', '        if (balances[msg.sender] + _value <= balances[msg.sender]) {\n', '            return false;\n', '        }\n', '        totalSupply += _value;\n', '        balances[msg.sender] += _value;\n', '        return true;\n', '    }\n', '\n', '\n', '    \n', '}']
