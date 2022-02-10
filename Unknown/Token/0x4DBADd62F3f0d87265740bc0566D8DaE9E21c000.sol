['contract IProxyManagement { \n', '    function isProxyLegit(address _address) returns (bool){}\n', '    function raiseTransferEvent(address _from, address _to, uint _ammount){}\n', '    function raiseApprovalEvent(address _sender,address _spender,uint _value){}\n', '    function dedicatedProxyAddress() constant returns (address contractAddress){}\n', '}\n', '\n', 'contract ITokenRecipient { \n', '\tfunction receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); \n', '}\n', '\n', 'contract IFundManagement {\n', '\tfunction fundsCombinedValue() constant returns (uint value){}\n', '    function getFundAlterations() returns (uint alterations){}\n', '}\n', '\n', 'contract IERC20Token {\n', '\n', '    function totalSupply() constant returns (uint256 supply);\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract MacroTokenContract{\n', '    \n', '    address public dev;\n', '    address public curator;\n', '    address public mintingContractAddress;\n', '    address public destructionContractAddress;\n', '    uint256 public totalSupply = 0;\n', '    bool public lockdown = false;\n', '\n', "    string public standard = 'Macro token';\n", "    string public name = 'Macro';\n", "    string public symbol = 'MCR';\n", '    uint8 public decimals = 8;\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    IProxyManagement proxyManagementContract;\n', '    IFundManagement fundManagementContract;\n', '\n', '    uint public weiForMcr;\n', '    uint public mcrAmmountForGas;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Mint(address _destination, uint _amount);\n', '    event Destroy(address _destination, uint _amount);\n', '    event McrForGasFailed(address _failedAddress, uint _ammount);\n', '\n', '    function MacroTokenContract() { \n', '        dev = msg.sender;\n', '    }\n', '    \n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success){\n', '        if(balances[msg.sender] < _value) throw;\n', '        if(balances[_to] + _value <= balances[_to]) throw;\n', '        if(lockdown) throw;\n', '\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '        createTransferEvent(true, msg.sender, _to, _value);              \n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if(balances[_from] < _value) throw;\n', '        if(balances[_to] + _value <= balances[_to]) throw;\n', '        if(_value > allowed[_from][msg.sender]) throw;\n', '        if(lockdown) throw;\n', '\n', '        balances[_from] -= _value;\n', '        balances[_to] += _value;\n', '        createTransferEvent(true, _from, _to, _value);\n', '        allowed[_from][msg.sender] -= _value;\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        if(lockdown) throw;\n', '        \n', '        allowed[msg.sender][_spender] = _value;\n', '        createApprovalEvent(true, msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    function transferViaProxy(address _source, address _to, uint256 _amount) returns (bool success){\n', '        if (!proxyManagementContract.isProxyLegit(msg.sender)) throw;\n', '        if (balances[_source] < _amount) throw;\n', '        if (balances[_to] + _amount <= balances[_to]) throw;\n', '        if (lockdown) throw;\n', '\n', '        balances[_source] -= _amount;\n', '        balances[_to] += _amount;\n', '\n', '        if (msg.sender == proxyManagementContract.dedicatedProxyAddress()){\n', '            createTransferEvent(false, _source, _to, _amount); \n', '        }else{\n', '            createTransferEvent(true, _source, _to, _amount); \n', '        }\n', '        return true;\n', '    }\n', '    \n', '    function transferFromViaProxy(address _source, address _from, address _to, uint256 _amount) returns (bool success) {\n', '        if (!proxyManagementContract.isProxyLegit(msg.sender)) throw;\n', '        if (balances[_from] < _amount) throw;\n', '        if (balances[_to] + _amount <= balances[_to]) throw;\n', '        if (lockdown) throw;\n', '        if (_amount > allowed[_from][_source]) throw;\n', '\n', '        balances[_from] -= _amount;\n', '        balances[_to] += _amount;\n', '        allowed[_from][_source] -= _amount;\n', '\n', '        if (msg.sender == proxyManagementContract.dedicatedProxyAddress()){\n', '            createTransferEvent(false, _source, _to, _amount); \n', '        }else{\n', '            createTransferEvent(true, _source, _to, _amount); \n', '        }\n', '        return true;\n', '    }\n', '    \n', '    function approveViaProxy(address _source, address _spender, uint256 _value) returns (bool success) {\n', '        if (!proxyManagementContract.isProxyLegit(msg.sender)) throw;\n', '        if(lockdown) throw;\n', '        \n', '        allowed[_source][_spender] = _value;\n', '        if (msg.sender == proxyManagementContract.dedicatedProxyAddress()){\n', '            createApprovalEvent(false, _source, _spender, _value);\n', '        }else{\n', '            createApprovalEvent(true, _source, _spender, _value);\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function mint(address _destination, uint _amount) returns (bool success){\n', '        if (msg.sender != mintingContractAddress) throw;\n', '        if(balances[_destination] + _amount < balances[_destination]) throw;\n', '        if(totalSupply + _amount < totalSupply) throw;\n', '\n', '        totalSupply += _amount;\n', '        balances[_destination] += _amount;\n', '        Mint(_destination, _amount);\n', '        createTransferEvent(true, 0x0, _destination, _amount);\n', '        return true;\n', '    }\n', '\n', '    function destroy(address _destination, uint _amount) returns (bool success) {\n', '        if (msg.sender != destructionContractAddress) throw;\n', '        if (balances[_destination] < _amount) throw;\n', '\n', '        totalSupply -= _amount;\n', '        balances[_destination] -= _amount;\n', '        Destroy(_destination, _amount);\n', '        createTransferEvent(true, _destination, 0x0, _amount);\n', '        return true;\n', '    }\n', '\n', '    function setTokenCurator(address _curatorAddress){\n', '        if( msg.sender != dev) throw;\n', '        curator = _curatorAddress;\n', '    }\n', '    \n', '    function setMintingContractAddress(address _contractAddress){ \n', '        if (msg.sender != curator) throw;\n', '        mintingContractAddress = _contractAddress;\n', '    }\n', '\n', '    function setDescrutionContractAddress(address _contractAddress){ \n', '        if (msg.sender != curator) throw;\n', '        destructionContractAddress = _contractAddress;\n', '    }\n', '\n', '    function setProxyManagementContract(address _contractAddress){\n', '        if (msg.sender != curator) throw;\n', '        proxyManagementContract = IProxyManagement(_contractAddress);\n', '    }\n', '\n', '    function setFundManagementContract(address _contractAddress){\n', '        if (msg.sender != curator) throw;\n', '        fundManagementContract = IFundManagement(_contractAddress);\n', '    }\n', '\n', '    function emergencyLock() {\n', '        if (msg.sender != curator && msg.sender != dev) throw;\n', '        \n', '        lockdown = !lockdown;\n', '    }\n', '\n', '    function killContract(){\n', '        if (msg.sender != dev) throw;\n', '        selfdestruct(dev);\n', '    }\n', '\n', '    function setWeiForMcr(uint _value){\n', '        if (msg.sender != curator) throw;\n', '        weiForMcr = _value;\n', '    }\n', '    \n', '    function setMcrAmountForGas(uint _value){\n', '        if (msg.sender != curator) throw;\n', '        mcrAmmountForGas = _value;\n', '    }\n', '\n', '    function getGasForMcr(){\n', '        if (balances[msg.sender] < mcrAmmountForGas) throw;\n', '        if (balances[curator] > balances[curator] + mcrAmmountForGas) throw;\n', '        if (this.balance < weiForMcr * mcrAmmountForGas) throw;\n', '\n', '        balances[msg.sender] -= mcrAmmountForGas;\n', '        balances[curator] += mcrAmmountForGas;\n', '        createTransferEvent(true, msg.sender, curator, weiForMcr * mcrAmmountForGas);\n', '        if (!msg.sender.send(weiForMcr * mcrAmmountForGas)) {\n', '            McrForGasFailed(msg.sender, weiForMcr * mcrAmmountForGas);\n', '        }\n', '    }\n', '\n', '    function fundManagementAddress() constant returns (address fundManagementAddress){\n', '        return address(fundManagementContract);\n', '    }\n', '\n', '    function proxyManagementAddress() constant returns (address proxyManagementAddress){\n', '        return address(proxyManagementContract);\n', '    }\n', '\n', '    function fundsCombinedValue() constant returns (uint value){\n', '        return fundManagementContract.fundsCombinedValue();\n', '    }\n', '\n', '    function getGasForMcrData() constant returns (uint, uint){\n', '        return (weiForMcr, mcrAmmountForGas);\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        ITokenRecipient spender = ITokenRecipient(_spender);\n', '        spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '        return true;\n', '    }\n', '\n', '    function createTransferEvent(bool _relayEvent, address _from, address _to, uint256 _value) internal {\n', '        if (_relayEvent){\n', '            proxyManagementContract.raiseTransferEvent(_from, _to, _value);\n', '        }\n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '    function createApprovalEvent(bool _relayEvent, address _sender, address _spender, uint _value) internal {\n', '        if (_relayEvent){\n', '            proxyManagementContract.raiseApprovalEvent(_sender, _spender, _value);\n', '        }\n', '        Approval(_sender, _spender, _value);\n', '    }\n', '    \n', '    function fillContract() payable{\n', '        if (msg.sender != curator) throw;\n', '    }\n', '}']