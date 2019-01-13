//Current version:0.4.25+commit.59dbf8f1.Emscripten.clang
pragma solidity 0.4.25;


contract RSVP {

    address public owner;
    uint RESERVATION = 0;
    uint UNLOCKING = 1;
    uint state;

    uint public stakeholders;

    mapping(address => bool) public bookings;
    mapping(bytes32 => bool) stakes;

    modifier restricted () {
        require(msg.sender == owner);
        _;
    }

    constructor() public{
        owner = msg.sender;
        state = RESERVATION;
        stakeholders = 0;
    }

    function addCode(string _code) public restricted {
        bytes32 hash = sha3(_code);
        require (stakes[hash] == false); // Don't overwrite previous mappings and return false
        stakes[hash] = true;
    }

    function verifyCode(string _code) view public restricted returns (bool) {
        bytes32 hash = sha3(_code);
        return stakes[hash];
    }

    //E' possibile sbloccare una puntata con qualsiasi codice
    function unlockStake(string _code) public {
        bytes32 hash = sha3(_code);

        require(state == UNLOCKING);
        require(bookings[msg.sender] == true);
        require(stakes[hash] == true);

        stakes[hash] = false;
        bookings[msg.sender] == false;
        stakeholders --;
        msg.sender.transfer(0.03 ether);

    }

    //E' possibile fare una puntata anche se non sono stati inseriti ancora codici
    function reserveSeat() payable public {
        require(state == RESERVATION);
        require(msg.value == 0.03 ether);
        require(bookings[msg.sender] == false);
        bookings[msg.sender] = true;
        stakeholders ++;
    }

    function() payable public {
        reserveSeat();
    }

    function stopRSVP() public restricted {
        state = UNLOCKING;
    }

    function close() public restricted {
        selfdestruct(owner);
    }

}








