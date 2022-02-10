['pragma solidity ^0.4.19;\n', '\n', 'contract Readings {\n', '    \n', '    address private owner;\n', '    mapping (bytes32 => MeterInfo) private meters;\n', '    bool private enabled;\n', '    \n', '    struct MeterInfo {\n', '        uint32 meterId;\n', '        string serialNumber;\n', '        string meterType;\n', '        string latestReading;\n', '    }\n', '    \n', '    function Readings() public {\n', '        owner = msg.sender;\n', '        enabled = true;\n', '    }\n', ' \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        owner = newOwner;\n', '    }\n', '    \n', '    function enable() public onlyOwner {\n', '        enabled = true;\n', '    }\n', '    \n', '    function disable() public onlyOwner {\n', '        enabled = false;\n', '    }\n', '    \n', '    function addMeter(uint32 meterId, string serialNumber, string meterType) public onlyOwner {\n', '        require(enabled && meterId > 0);\n', '        meters[keccak256(serialNumber)] = \n', '            MeterInfo({meterId: meterId, serialNumber:serialNumber, meterType:meterType, latestReading:""});\n', '    }\n', '    \n', '    function getMeter(string serialNumber) public view onlyOwner returns(string, uint32, string, string, string, string) {\n', '        bytes32 serialK = keccak256(serialNumber);\n', '        require(enabled && meters[serialK].meterId > 0);\n', '        \n', '        return ("Id:", meters[serialK].meterId, "Серийный номер:", meters[serialK].serialNumber, "Тип счетчика:", meters[serialK].meterType);\n', '    }\n', '    \n', '    function saveReading(string serialNumber, string reading) public onlyOwner {\n', '        bytes32 serialK = keccak256(serialNumber);\n', '        require (enabled && meters[serialK].meterId > 0);\n', '        meters[serialK].latestReading = reading;\n', '    }\n', '    \n', '    function getLatestReading(string serialNumber) public view returns (string, string, string, string, string, string) {\n', '        bytes32 serialK = keccak256(serialNumber);\n', '        require(enabled && meters[serialK].meterId > 0);\n', '        \n', '        return (\n', '            "Тип счетчика:", meters[serialK].meterType,\n', '            "Серийный номер:", meters[serialK].serialNumber,\n', '            "Показания:", meters[serialK].latestReading\n', '        );\n', '    }\n', '}']
['pragma solidity ^0.4.19;\n', '\n', 'contract Readings {\n', '    \n', '    address private owner;\n', '    mapping (bytes32 => MeterInfo) private meters;\n', '    bool private enabled;\n', '    \n', '    struct MeterInfo {\n', '        uint32 meterId;\n', '        string serialNumber;\n', '        string meterType;\n', '        string latestReading;\n', '    }\n', '    \n', '    function Readings() public {\n', '        owner = msg.sender;\n', '        enabled = true;\n', '    }\n', ' \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        owner = newOwner;\n', '    }\n', '    \n', '    function enable() public onlyOwner {\n', '        enabled = true;\n', '    }\n', '    \n', '    function disable() public onlyOwner {\n', '        enabled = false;\n', '    }\n', '    \n', '    function addMeter(uint32 meterId, string serialNumber, string meterType) public onlyOwner {\n', '        require(enabled && meterId > 0);\n', '        meters[keccak256(serialNumber)] = \n', '            MeterInfo({meterId: meterId, serialNumber:serialNumber, meterType:meterType, latestReading:""});\n', '    }\n', '    \n', '    function getMeter(string serialNumber) public view onlyOwner returns(string, uint32, string, string, string, string) {\n', '        bytes32 serialK = keccak256(serialNumber);\n', '        require(enabled && meters[serialK].meterId > 0);\n', '        \n', '        return ("Id:", meters[serialK].meterId, "Серийный номер:", meters[serialK].serialNumber, "Тип счетчика:", meters[serialK].meterType);\n', '    }\n', '    \n', '    function saveReading(string serialNumber, string reading) public onlyOwner {\n', '        bytes32 serialK = keccak256(serialNumber);\n', '        require (enabled && meters[serialK].meterId > 0);\n', '        meters[serialK].latestReading = reading;\n', '    }\n', '    \n', '    function getLatestReading(string serialNumber) public view returns (string, string, string, string, string, string) {\n', '        bytes32 serialK = keccak256(serialNumber);\n', '        require(enabled && meters[serialK].meterId > 0);\n', '        \n', '        return (\n', '            "Тип счетчика:", meters[serialK].meterType,\n', '            "Серийный номер:", meters[serialK].serialNumber,\n', '            "Показания:", meters[serialK].latestReading\n', '        );\n', '    }\n', '}']
