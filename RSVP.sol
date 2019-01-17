//Current version:0.5.2+commit.1df8f40c.Emscripten.clang
pragma solidity ^0.5.2;

/// @title  Reservez s'il vous plait
/// @author CagliariEthereumLab
/// @notice RSVP aka Reservez s'il vous plait version 0.0.2

contract RSVP {

    address payable public owner;
    
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
    
        stakes[0xb5df3df90096adbf1064ca4d3a941804aa128ae9a3f6b002927031f0b444b940] = true;      // 7oFWHucvCep#kQ 8BcVG^6!qD8Dh!
        stakes[0x3dfe51ad918da5db69b64e106f00a22f9d03c5fc0adbcbe21f89cdf5217b56d3] = true;      // ZV%i$7DbNwhNfG SA7@7Pjb8Q$5Y3
        stakes[0xb68847abc22eebe683fb37c6f051dfe2459574fd27e88c0f172f0ebae61a11ed] = true;      // 5kDtgrre%Mgj%r q8Rdq$MXMmEQmY
        stakes[0xbfcba4a224909a1c747e574172253e1d04ced0d88aa014f035a2d0f9ee12986f] = true;      // N%NwB4vYhi!Wj@ o5#WJos%ZPeJut
        stakes[0x49fafcdae33b60ef6a1b1b79bfe06abb7b2c957b63ba9e0722d5b582b1608731] = true;      // hLfTh!R2PTaTK@ Xg@62QmATe$UmT
        stakes[0x39d09b3d6283ba9c33fd33e0462a182cd63cbf395ee907d2923dcc90700904ec] = true;      // 3H6mGw7Xu7%6^J kma%kWDb9#2ng5
        stakes[0xaa688b9f657882ac64974fb93d08a1a28597f451f242594502e4017a9fb5855b] = true;      // X%vgw#u$uu7rh! k$AVtDAk386RSt
        stakes[0x7a3f2c37a54d06b5d0e1362e86def1ba50940c7650259f54f64afa9eba815f22] = true;      // !#T%SpETT7bWEk U^x$XRP@3j%2Nd
        stakes[0x4aa5ce081cabacda29ae40aefac31f6e9fb9d81528cc9d769a1dbd4f27f45f65] = true;      // UX6xZz$2$iCY%J im7yssf8^ZZ9Ek
        stakes[0x4e2c652637a31c08c5862eff811e68ea2e770d751317282db32d976ab4034457] = true;      // $X%W3swMV7H9Ew D5uRDRkmWict$%
        stakes[0x4ad1366ac358ff3c276976ff7e8f260c3c2883c47b68b2deedfb24c2d0ef6309] = true;      // PuN8DkggGW!W6@ CBTKyuU4mg$gnV
        stakes[0x05bb64605e7f57c47e61865a80cd95462c74f4d10cf481925b704a42751b5c54] = true;      // 3HmYZq^X5Lj!Sm !xCy9GcCFbNu6b
        stakes[0xfaaa86f1daa95388d9963b76e84fdf3e73ed62bc689a7afb4336f7d958f15371] = true;      // N5QsahGuMtv6^V ^Bt9NKRT4FkTFT
        stakes[0x24dd05fbe7c92f2072b39fc939bd6bcc77911415ba16c2af4a8cce8e6efb755b] = true;      // 4kPMk7!MbC3YC@ 5LFvm3yNX@!8#7
        stakes[0x41c63743f0429359dd2767e8c231fa6d1d4eafefb6fbe140a944e1ff09baa5c9] = true;      // r!6v5VffVUNFX^ FuD4R%4AC8w4X8
        stakes[0xe13e98c3897c98e6a26d41e0c93f68e02185408fe416563a0ada981c91f24ef2] = true;      // noTrbid2rg@hBM yQxNDg!cD#j@U8
        stakes[0x2a38be6d68784b55c3362277cf749aba0ddd05219c2da938393f7af8f24f419e] = true;      // #7NFNcLhQ9ifVF 3S$#xoJx2Y2UAk
        stakes[0x0f853d93820fc6b45f124c6f75c86519ee6bb79b7e6f0e17419811b3e121cb9b] = true;      // @Xcdhoj6JPkRk# 7yNg@9X%b@DorV
        stakes[0xed494de5f524cd9c3b961d612d555ea5172218460cdbc34b54fc8367b27e65d3] = true;      // bFj448!EMjLVW$ !4VK5!nz$Hwcup
        stakes[0xf7436155ce5c081ba1c64599d615c0929b97e5cc79f3a6c445baa8299653ef05] = true;      // yuV^vqFy66@uwd tNs6SuhmNUV9N^

        stakeholders = 0;
    }

    function addCode(bytes32 _hashedCode) public restricted {
        require (stakes[_hashedCode] == false); // Don't overwrite previous mappings and return false
        stakes[_hashedCode] = true;
    }

    function verifyCode(string memory _code) view public restricted returns (bool) {
        bytes32 hash =  keccak256(bytes(_code));
        return stakes[hash];
    }

    //E' possibile sbloccare una puntata con qualsiasi codice
    function unlockStake(string memory _code) public {
        bytes32 hash =  keccak256(bytes(_code));

        require(state == UNLOCKING);
        require(bookings[msg.sender] == true);
        require(stakes[hash] == true);

        stakes[hash] = false;
        bookings[msg.sender] == false;
        stakeholders --;
        msg.sender.transfer(0.010 ether);

    }

    //E' possibile fare una puntata anche se non sono stati inseriti ancora codici
    function reserveSeat() payable public {
        require(state == RESERVATION);
        require(msg.value == 0.010 ether);
        require(bookings[msg.sender] == false);
        bookings[msg.sender] = true;
        stakeholders ++;
    }

    function() payable  external {
        reserveSeat();
    }

    function stopRSVP() public restricted {
        state = UNLOCKING;
    }

    function close() public restricted {
        selfdestruct(owner);
    }

}








