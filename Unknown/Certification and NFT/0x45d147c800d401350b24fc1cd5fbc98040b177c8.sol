['pragma solidity ^0.4.2;\n', 'contract Token{\n', '\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '  event Approval(address indexed _onwer,address indexed _spender, uint256 _value);\n', '\n', '  function totalSupply() constant returns(uint256 totalSupply){}\n', '\n', '  function balanceOf(address _owner) constant returns (uint256 balance){}\n', '\n', '  function transfer(address _to, uint256 _value) constant returns(bool success){}\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) constant returns (bool success){}\n', '\n', '  function approve(address _spender, uint256 _value) constant returns(bool success){}\n', '\n', '  function allowance(address _owner, uint _spender) constant returns(uint256 remaining){}\n', '\n', '}\n', '\n', 'contract StandardToken is Token{\n', '  uint256 public totalSupply;\n', '  mapping(address => uint256)balances;\n', '  mapping(address =>mapping(address=>uint256))allowed;\n', '\n', '\n', '  function transfer(address _to, uint256 _value)constant returns(bool success){\n', '    if(balances[msg.sender]>_value && balances[_to]+_value>balances[_to]) {\n', '      balances[msg.sender] -= _value;\n', '      balances[_to] +=_value;\n', '      Transfer(msg.sender,_to,_value);\n', '      return true;\n', '    } else {\n', '      return false;\n', '    }\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value)constant returns(bool success){\n', '    if(balances[_from]>_value && allowed[_from][msg.sender]>_value && balances[_to]+_value>balances[_to]){\n', '      balances[_from]-=_value;\n', '      allowed[_from][msg.sender]-=_value;\n', '      balances[_to]-=_value;\n', '      Transfer(_from,_to,_value);\n', '      return true;\n', '    } else {\n', '      return false;\n', '    }\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value)constant returns (bool success){\n', '    allowed[msg.sender][_spender]=_value;\n', '    Approval(msg.sender,_spender,_value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint256 balance){\n', '    return balances[_owner];\n', '  }\n', '\n', '  function allowance(address _onwer,address _spender) constant returns(uint256 allowance){\n', '    return allowed[_onwer][_spender];\n', '  }\n', '}\n', '\n', 'contract NinjaToken is StandardToken{\n', '    string public name ="NinjaToken";\n', '    string public version="0.0.1";\n', '    uint public decimals = 18;\n', '    mapping(address=>string) public commit;\n', '    \n', '    address public founder;\n', '    address public admin; \n', '    bool public fundingLock=true;  // indicate funding status activate or inactivate\n', '    address public fundingAccount;\n', '    uint public startBlock;        //Crowdsale startBlock\n', '    uint public blockDuration;     // Crowdsale blocks duration\n', '    uint public fundingExchangeRate;\n', '    uint public price=10;\n', '    bool public transferLock=false;  // indicate transfer status activate or inactivate\n', '\n', '    event Funding(address sender, uint256 eth);\n', '    event Buy(address buyer, uint256 eth);\n', '    \n', '    function NinjaToken(address _founder,address _admin){\n', '        founder=_founder;\n', '        admin=_admin;\n', '    }\n', '    \n', '    function changeFunder(address _founder,address _admin){\n', '        if(msg.sender!=admin) throw;\n', '        founder=_founder;\n', '        admin=_admin;        \n', '    }\n', '    \n', '    function setFundingLock(bool _fundinglock,address _fundingAccount){\n', '        if(msg.sender!=founder) throw;\n', '        fundingLock=_fundinglock;\n', '        fundingAccount=_fundingAccount;\n', '    }\n', '    \n', '    function setFundingEnv(uint _startBlock, uint _blockDuration,uint _fundingExchangeRate){\n', '        if(msg.sender!=founder) throw;\n', '        startBlock=_startBlock;\n', '        blockDuration=_blockDuration;\n', '        fundingExchangeRate=_fundingExchangeRate;\n', '    }\n', '    \n', '    function funding() payable {\n', '        if(fundingLock||block.number<startBlock||block.number>startBlock+blockDuration) throw;\n', '        if(balances[msg.sender]>balances[msg.sender]+msg.value*fundingExchangeRate || msg.value>msg.value*fundingExchangeRate) throw;\n', '        if(!fundingAccount.call.value(msg.value)()) throw;\n', '        balances[msg.sender]+=msg.value*fundingExchangeRate;\n', '        Funding(msg.sender,msg.value);\n', '    }\n', '    \n', '    function setPrice(uint _price,bool _transferLock){\n', '        if(msg.sender!=founder) throw;\n', '        price=_price;\n', '        transferLock=_transferLock;\n', '    }\n', '    \n', '    function buy(string _commit) payable{\n', '        if(balances[msg.sender]>balances[msg.sender]+msg.value*price || msg.value>msg.value*price) throw;\n', '        if(!fundingAccount.call.value(msg.value)()) throw;\n', '        balances[msg.sender]+=msg.value*price;\n', '        commit[msg.sender]=_commit;\n', '        Buy(msg.sender,msg.value);\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _value)constant returns(bool success){\n', '        if(transferLock) throw;\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value)constant returns(bool success){\n', '        if(transferLock) throw;\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '}']