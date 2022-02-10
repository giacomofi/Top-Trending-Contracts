['pragma solidity ^0.5.0;\n', '\n', 'contract Adoption {\n', '  address[16] public adopters;\n', '  uint[16] public prices;\n', '\n', '  constructor() public {\n', '    for (uint i=0;i<16;++i) {\n', '      prices[i] = 0.001 ether;  \n', '    }\n', '  }\n', '\n', '  // Adopting a pet\n', '  function adopt(uint petId) public payable returns (uint) {\n', '    require(petId >= 0 && petId <= 15);\n', '    require(msg.value >= prices[petId]);\n', '\n', '    prices[petId] *= 120;\n', '    prices[petId] /= 100;\n', '\n', '    adopters[petId] = msg.sender;\n', '    return petId;\n', '  }\n', '\n', '  // Retrieving the adopters\n', '  function getAdopters() public view returns (address[16] memory, uint[16] memory) {\n', '    return (adopters,  prices);\n', '  }\n', '}']