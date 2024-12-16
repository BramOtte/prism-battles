{
const l_attack = document.querySelectorAll(".line .stat.attack");
const l_defense = document.querySelectorAll(".line .stat.defense");
const l_ranged = document.querySelectorAll(".line .stat.ranged");
const l_movement = document.querySelectorAll(".line .stat.movement");
const l_power = document.querySelectorAll(".line .stat.power");


const l_talents = [...document.querySelector(".talents ul il")]
    .map(child => {
        return child.textContent;
    });
const l_powers = document.querySelector(".powers ul il");

const l_cards = document.querySelectorAll(".single_unit .cards .icon-mb_card").length;
const l_minis = document.querySelectorAll(".single_unit .cards .icon-mbpawn").length;

const art_of_war = document.querySelectorAll(".single_unit .cards .icon-mbaow").length;

const cost = Number(document.querySelector(".details .recruitment_cost").textContent.split(":").at(1));
const name = document.querySelector(".details h3").textContent;

console.log(`cost: ${cost}`);
console.log(name);
console.log("cards", l_cards);
console.log("minis", l_minis);

console.log("art of war", art_of_war);
console.log("talents", l_talents);


let output = "";

for (let i = 0; i < l_attack.length; i += 1) {
    const attack = Number(l_attack[i].textContent);
    const defense = Number(l_defense[i].textContent);
    const ranged = Number(l_ranged[i].textContent);
    const movement = Number(l_movement[i].textContent);
    const powers = [...l_power[i].children].map(child => {
        if (child.textContent === "-") {
            return 0;
        }
        if (child.textContent === "") {
            return 1;
        }
        return Number(child.textContent);
    });

    output += `${attack} ${defense} ${ranged} ${movement} ${powers.join(" ")}\n`;
}
console.log(output);
}