['contract DigitalPadlock {\n', '    string public message;\n', '\n', '    function DigitalPadlock(string _m) public {\n', '        message = _m;\n', '    }\n', '}\n', '\n', 'contract EthernalLoveParent {\n', '  address owner;\n', '  address[] public padlocks;\n', '  event LogCreatedValentine(address padlock); // maybe listen for events\n', '\n', '  function EthernalLoveParent() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  function createPadlock(string _m) public {\n', '    DigitalPadlock d = new DigitalPadlock(_m);\n', '    LogCreatedValentine(d); // emit an event\n', '    padlocks.push(d); \n', '  }\n', '}']
['contract DigitalPadlock {\n', '    string public message;\n', '\n', '    function DigitalPadlock(string _m) public {\n', '        message = _m;\n', '    }\n', '}\n', '\n', 'contract EthernalLoveParent {\n', '  address owner;\n', '  address[] public padlocks;\n', '  event LogCreatedValentine(address padlock); // maybe listen for events\n', '\n', '  function EthernalLoveParent() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  function createPadlock(string _m) public {\n', '    DigitalPadlock d = new DigitalPadlock(_m);\n', '    LogCreatedValentine(d); // emit an event\n', '    padlocks.push(d); \n', '  }\n', '}']