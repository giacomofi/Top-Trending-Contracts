['pragma solidity ^0.4.17;\n', '\n', 'contract TinyProxy {\n', '  address public receiver;\n', '  uint public gasBudget;\n', '\n', '  function TinyProxy(address toAddr, uint proxyGas) public {\n', '    receiver = toAddr;\n', '    gasBudget = proxyGas;\n', '  }\n', '\n', '  function () payable public { }\n', '\n', '  event FundsReleased(address to, uint amount);\n', '\n', '  function release() public {\n', '    uint balance = address(this).balance;\n', '    if(gasBudget > 0){\n', '      require(receiver.call.gas(gasBudget).value(balance)());\n', '    } else {\n', '      require(receiver.send(balance));\n', '    }\n', '    FundsReleased(receiver, balance);\n', '  }\n', '}\n', '\n', 'contract TinyProxyFactory {\n', '  mapping(address => mapping(address => address)) public proxyFor;\n', '  mapping(address => address[]) public userProxies;\n', '\n', '  function make(address to, uint gas, bool track) public returns(address proxy){\n', '    proxy = new TinyProxy(to, gas);\n', '    if(track) {\n', '      proxyFor[msg.sender][to] = proxy;\n', '      userProxies[msg.sender].push(proxy);\n', '    }\n', '    return proxy;\n', '  }\n', '}']
['pragma solidity ^0.4.17;\n', '\n', 'contract TinyProxy {\n', '  address public receiver;\n', '  uint public gasBudget;\n', '\n', '  function TinyProxy(address toAddr, uint proxyGas) public {\n', '    receiver = toAddr;\n', '    gasBudget = proxyGas;\n', '  }\n', '\n', '  function () payable public { }\n', '\n', '  event FundsReleased(address to, uint amount);\n', '\n', '  function release() public {\n', '    uint balance = address(this).balance;\n', '    if(gasBudget > 0){\n', '      require(receiver.call.gas(gasBudget).value(balance)());\n', '    } else {\n', '      require(receiver.send(balance));\n', '    }\n', '    FundsReleased(receiver, balance);\n', '  }\n', '}\n', '\n', 'contract TinyProxyFactory {\n', '  mapping(address => mapping(address => address)) public proxyFor;\n', '  mapping(address => address[]) public userProxies;\n', '\n', '  function make(address to, uint gas, bool track) public returns(address proxy){\n', '    proxy = new TinyProxy(to, gas);\n', '    if(track) {\n', '      proxyFor[msg.sender][to] = proxy;\n', '      userProxies[msg.sender].push(proxy);\n', '    }\n', '    return proxy;\n', '  }\n', '}']
