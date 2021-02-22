`timescale 1 ns/1 ns

module sincos(
    input  wire               rstn,
    input  wire               clk,
    input  wire               i_en,
    input  wire        [11:0] i_theta,      // a round is mapped to 0~4095
    output reg                o_en,
    output reg  signed [15:0] o_sin, o_cos  // -1~+1 is mapped to -16384~+16384
);

enum logic [2:0] {IDLE, S1, S2, S3, S4, S5} stat;

reg [11:0] theta_a, theta_b;
reg        cos_z, cos_s, sin_z, sin_s;
reg [ 9:0] rom_x;
reg [14:0] rom_y;
reg signed [15:0] cos_tmp;

always @ (posedge clk or negedge rstn)
    if(~rstn) begin
        stat <= IDLE;
        {theta_a, theta_b} <= '0;
        {cos_z, cos_s, sin_z, sin_s} <= '0;
        rom_x <= '0;
        cos_tmp <= '0;
        {o_en, o_sin, o_cos} <= '0;
    end else begin
        o_en <= 1'b0;
        case(stat)
            IDLE: if(i_en) begin
                stat <= S1;
                theta_a <= i_theta - 12'd1024;
                if(i_theta>12'd2048)
                    theta_b <= 12'd0 - i_theta;
                else
                    theta_b <= i_theta;
            end
            S1: begin
                stat <= S2;
                if(theta_a>12'd2048)
                    theta_b <= 12'd0 - theta_a;
                else
                    theta_b <= theta_a;
                if(theta_b>12'd1024) begin
                    rom_x <= 10'd0 - theta_b[9:0];
                    cos_z <= 1'b0;
                    cos_s <= 1'b1;
                end else begin
                    rom_x <= theta_b[9:0];
                    cos_z <= theta_b==12'd1024;
                    cos_s <= 1'b0;
                end
            end
            S2: begin
                stat <= S3;
                if(theta_b>12'd1024) begin
                    rom_x <= 10'd0 - theta_b[9:0];
                    sin_z <= 1'b0;
                    sin_s <= 1'b1;
                end else begin
                    rom_x <= theta_b[9:0];
                    sin_z <= theta_b==12'd1024;
                    sin_s <= 1'b0;
                end
            end
            S3: begin
                stat <= S4;
                if(cos_z)
                    cos_tmp <= '0;
                else if(cos_s)
                    cos_tmp <= -$signed({1'b0,rom_y});
                else
                    cos_tmp <=  $signed({1'b0,rom_y});
            end
            S4: begin
                stat <= S5;
                o_en <= 1'b1;
                o_cos <= cos_tmp;
                if(sin_z)
                    o_sin <= '0;
                else if(sin_s)
                    o_sin <= -$signed({1'b0,rom_y});
                else
                    o_sin <= $signed({1'b0,rom_y});
            end
            S5: stat <= IDLE;
        endcase
    end

always @ (posedge clk)
case(rom_x)
10'd0:rom_y<=15'd16384;
10'd1:rom_y<=15'd16384;
10'd2:rom_y<=15'd16384;
10'd3:rom_y<=15'd16384;
10'd4:rom_y<=15'd16384;
10'd5:rom_y<=15'd16384;
10'd6:rom_y<=15'd16383;
10'd7:rom_y<=15'd16383;
10'd8:rom_y<=15'd16383;
10'd9:rom_y<=15'd16382;
10'd10:rom_y<=15'd16382;
10'd11:rom_y<=15'd16382;
10'd12:rom_y<=15'd16381;
10'd13:rom_y<=15'd16381;
10'd14:rom_y<=15'd16380;
10'd15:rom_y<=15'd16380;
10'd16:rom_y<=15'd16379;
10'd17:rom_y<=15'd16378;
10'd18:rom_y<=15'd16378;
10'd19:rom_y<=15'd16377;
10'd20:rom_y<=15'd16376;
10'd21:rom_y<=15'd16375;
10'd22:rom_y<=15'd16375;
10'd23:rom_y<=15'd16374;
10'd24:rom_y<=15'd16373;
10'd25:rom_y<=15'd16372;
10'd26:rom_y<=15'd16371;
10'd27:rom_y<=15'd16370;
10'd28:rom_y<=15'd16369;
10'd29:rom_y<=15'd16368;
10'd30:rom_y<=15'd16367;
10'd31:rom_y<=15'd16365;
10'd32:rom_y<=15'd16364;
10'd33:rom_y<=15'd16363;
10'd34:rom_y<=15'd16362;
10'd35:rom_y<=15'd16360;
10'd36:rom_y<=15'd16359;
10'd37:rom_y<=15'd16358;
10'd38:rom_y<=15'd16356;
10'd39:rom_y<=15'd16355;
10'd40:rom_y<=15'd16353;
10'd41:rom_y<=15'd16352;
10'd42:rom_y<=15'd16350;
10'd43:rom_y<=15'd16348;
10'd44:rom_y<=15'd16347;
10'd45:rom_y<=15'd16345;
10'd46:rom_y<=15'd16343;
10'd47:rom_y<=15'd16341;
10'd48:rom_y<=15'd16340;
10'd49:rom_y<=15'd16338;
10'd50:rom_y<=15'd16336;
10'd51:rom_y<=15'd16334;
10'd52:rom_y<=15'd16332;
10'd53:rom_y<=15'd16330;
10'd54:rom_y<=15'd16328;
10'd55:rom_y<=15'd16326;
10'd56:rom_y<=15'd16324;
10'd57:rom_y<=15'd16321;
10'd58:rom_y<=15'd16319;
10'd59:rom_y<=15'd16317;
10'd60:rom_y<=15'd16315;
10'd61:rom_y<=15'd16312;
10'd62:rom_y<=15'd16310;
10'd63:rom_y<=15'd16308;
10'd64:rom_y<=15'd16305;
10'd65:rom_y<=15'd16303;
10'd66:rom_y<=15'd16300;
10'd67:rom_y<=15'd16298;
10'd68:rom_y<=15'd16295;
10'd69:rom_y<=15'd16292;
10'd70:rom_y<=15'd16290;
10'd71:rom_y<=15'd16287;
10'd72:rom_y<=15'd16284;
10'd73:rom_y<=15'd16281;
10'd74:rom_y<=15'd16279;
10'd75:rom_y<=15'd16276;
10'd76:rom_y<=15'd16273;
10'd77:rom_y<=15'd16270;
10'd78:rom_y<=15'd16267;
10'd79:rom_y<=15'd16264;
10'd80:rom_y<=15'd16261;
10'd81:rom_y<=15'd16258;
10'd82:rom_y<=15'd16255;
10'd83:rom_y<=15'd16251;
10'd84:rom_y<=15'd16248;
10'd85:rom_y<=15'd16245;
10'd86:rom_y<=15'd16242;
10'd87:rom_y<=15'd16238;
10'd88:rom_y<=15'd16235;
10'd89:rom_y<=15'd16232;
10'd90:rom_y<=15'd16228;
10'd91:rom_y<=15'd16225;
10'd92:rom_y<=15'd16221;
10'd93:rom_y<=15'd16218;
10'd94:rom_y<=15'd16214;
10'd95:rom_y<=15'd16210;
10'd96:rom_y<=15'd16207;
10'd97:rom_y<=15'd16203;
10'd98:rom_y<=15'd16199;
10'd99:rom_y<=15'd16195;
10'd100:rom_y<=15'd16192;
10'd101:rom_y<=15'd16188;
10'd102:rom_y<=15'd16184;
10'd103:rom_y<=15'd16180;
10'd104:rom_y<=15'd16176;
10'd105:rom_y<=15'd16172;
10'd106:rom_y<=15'd16168;
10'd107:rom_y<=15'd16164;
10'd108:rom_y<=15'd16160;
10'd109:rom_y<=15'd16156;
10'd110:rom_y<=15'd16151;
10'd111:rom_y<=15'd16147;
10'd112:rom_y<=15'd16143;
10'd113:rom_y<=15'd16138;
10'd114:rom_y<=15'd16134;
10'd115:rom_y<=15'd16130;
10'd116:rom_y<=15'd16125;
10'd117:rom_y<=15'd16121;
10'd118:rom_y<=15'd16116;
10'd119:rom_y<=15'd16112;
10'd120:rom_y<=15'd16107;
10'd121:rom_y<=15'd16103;
10'd122:rom_y<=15'd16098;
10'd123:rom_y<=15'd16093;
10'd124:rom_y<=15'd16088;
10'd125:rom_y<=15'd16084;
10'd126:rom_y<=15'd16079;
10'd127:rom_y<=15'd16074;
10'd128:rom_y<=15'd16069;
10'd129:rom_y<=15'd16064;
10'd130:rom_y<=15'd16059;
10'd131:rom_y<=15'd16054;
10'd132:rom_y<=15'd16049;
10'd133:rom_y<=15'd16044;
10'd134:rom_y<=15'd16039;
10'd135:rom_y<=15'd16034;
10'd136:rom_y<=15'd16029;
10'd137:rom_y<=15'd16024;
10'd138:rom_y<=15'd16018;
10'd139:rom_y<=15'd16013;
10'd140:rom_y<=15'd16008;
10'd141:rom_y<=15'd16002;
10'd142:rom_y<=15'd15997;
10'd143:rom_y<=15'd15991;
10'd144:rom_y<=15'd15986;
10'd145:rom_y<=15'd15980;
10'd146:rom_y<=15'd15975;
10'd147:rom_y<=15'd15969;
10'd148:rom_y<=15'd15964;
10'd149:rom_y<=15'd15958;
10'd150:rom_y<=15'd15952;
10'd151:rom_y<=15'd15946;
10'd152:rom_y<=15'd15941;
10'd153:rom_y<=15'd15935;
10'd154:rom_y<=15'd15929;
10'd155:rom_y<=15'd15923;
10'd156:rom_y<=15'd15917;
10'd157:rom_y<=15'd15911;
10'd158:rom_y<=15'd15905;
10'd159:rom_y<=15'd15899;
10'd160:rom_y<=15'd15893;
10'd161:rom_y<=15'd15887;
10'd162:rom_y<=15'd15881;
10'd163:rom_y<=15'd15875;
10'd164:rom_y<=15'd15868;
10'd165:rom_y<=15'd15862;
10'd166:rom_y<=15'd15856;
10'd167:rom_y<=15'd15849;
10'd168:rom_y<=15'd15843;
10'd169:rom_y<=15'd15837;
10'd170:rom_y<=15'd15830;
10'd171:rom_y<=15'd15824;
10'd172:rom_y<=15'd15817;
10'd173:rom_y<=15'd15810;
10'd174:rom_y<=15'd15804;
10'd175:rom_y<=15'd15797;
10'd176:rom_y<=15'd15791;
10'd177:rom_y<=15'd15784;
10'd178:rom_y<=15'd15777;
10'd179:rom_y<=15'd15770;
10'd180:rom_y<=15'd15763;
10'd181:rom_y<=15'd15757;
10'd182:rom_y<=15'd15750;
10'd183:rom_y<=15'd15743;
10'd184:rom_y<=15'd15736;
10'd185:rom_y<=15'd15729;
10'd186:rom_y<=15'd15722;
10'd187:rom_y<=15'd15715;
10'd188:rom_y<=15'd15707;
10'd189:rom_y<=15'd15700;
10'd190:rom_y<=15'd15693;
10'd191:rom_y<=15'd15686;
10'd192:rom_y<=15'd15679;
10'd193:rom_y<=15'd15671;
10'd194:rom_y<=15'd15664;
10'd195:rom_y<=15'd15656;
10'd196:rom_y<=15'd15649;
10'd197:rom_y<=15'd15642;
10'd198:rom_y<=15'd15634;
10'd199:rom_y<=15'd15627;
10'd200:rom_y<=15'd15619;
10'd201:rom_y<=15'd15611;
10'd202:rom_y<=15'd15604;
10'd203:rom_y<=15'd15596;
10'd204:rom_y<=15'd15588;
10'd205:rom_y<=15'd15581;
10'd206:rom_y<=15'd15573;
10'd207:rom_y<=15'd15565;
10'd208:rom_y<=15'd15557;
10'd209:rom_y<=15'd15549;
10'd210:rom_y<=15'd15541;
10'd211:rom_y<=15'd15533;
10'd212:rom_y<=15'd15525;
10'd213:rom_y<=15'd15517;
10'd214:rom_y<=15'd15509;
10'd215:rom_y<=15'd15501;
10'd216:rom_y<=15'd15493;
10'd217:rom_y<=15'd15485;
10'd218:rom_y<=15'd15476;
10'd219:rom_y<=15'd15468;
10'd220:rom_y<=15'd15460;
10'd221:rom_y<=15'd15451;
10'd222:rom_y<=15'd15443;
10'd223:rom_y<=15'd15435;
10'd224:rom_y<=15'd15426;
10'd225:rom_y<=15'd15418;
10'd226:rom_y<=15'd15409;
10'd227:rom_y<=15'd15401;
10'd228:rom_y<=15'd15392;
10'd229:rom_y<=15'd15383;
10'd230:rom_y<=15'd15375;
10'd231:rom_y<=15'd15366;
10'd232:rom_y<=15'd15357;
10'd233:rom_y<=15'd15349;
10'd234:rom_y<=15'd15340;
10'd235:rom_y<=15'd15331;
10'd236:rom_y<=15'd15322;
10'd237:rom_y<=15'd15313;
10'd238:rom_y<=15'd15304;
10'd239:rom_y<=15'd15295;
10'd240:rom_y<=15'd15286;
10'd241:rom_y<=15'd15277;
10'd242:rom_y<=15'd15268;
10'd243:rom_y<=15'd15259;
10'd244:rom_y<=15'd15250;
10'd245:rom_y<=15'd15240;
10'd246:rom_y<=15'd15231;
10'd247:rom_y<=15'd15222;
10'd248:rom_y<=15'd15213;
10'd249:rom_y<=15'd15203;
10'd250:rom_y<=15'd15194;
10'd251:rom_y<=15'd15184;
10'd252:rom_y<=15'd15175;
10'd253:rom_y<=15'd15166;
10'd254:rom_y<=15'd15156;
10'd255:rom_y<=15'd15146;
10'd256:rom_y<=15'd15137;
10'd257:rom_y<=15'd15127;
10'd258:rom_y<=15'd15118;
10'd259:rom_y<=15'd15108;
10'd260:rom_y<=15'd15098;
10'd261:rom_y<=15'd15088;
10'd262:rom_y<=15'd15078;
10'd263:rom_y<=15'd15069;
10'd264:rom_y<=15'd15059;
10'd265:rom_y<=15'd15049;
10'd266:rom_y<=15'd15039;
10'd267:rom_y<=15'd15029;
10'd268:rom_y<=15'd15019;
10'd269:rom_y<=15'd15009;
10'd270:rom_y<=15'd14999;
10'd271:rom_y<=15'd14989;
10'd272:rom_y<=15'd14978;
10'd273:rom_y<=15'd14968;
10'd274:rom_y<=15'd14958;
10'd275:rom_y<=15'd14948;
10'd276:rom_y<=15'd14937;
10'd277:rom_y<=15'd14927;
10'd278:rom_y<=15'd14917;
10'd279:rom_y<=15'd14906;
10'd280:rom_y<=15'd14896;
10'd281:rom_y<=15'd14885;
10'd282:rom_y<=15'd14875;
10'd283:rom_y<=15'd14864;
10'd284:rom_y<=15'd14854;
10'd285:rom_y<=15'd14843;
10'd286:rom_y<=15'd14832;
10'd287:rom_y<=15'd14822;
10'd288:rom_y<=15'd14811;
10'd289:rom_y<=15'd14800;
10'd290:rom_y<=15'd14789;
10'd291:rom_y<=15'd14779;
10'd292:rom_y<=15'd14768;
10'd293:rom_y<=15'd14757;
10'd294:rom_y<=15'd14746;
10'd295:rom_y<=15'd14735;
10'd296:rom_y<=15'd14724;
10'd297:rom_y<=15'd14713;
10'd298:rom_y<=15'd14702;
10'd299:rom_y<=15'd14691;
10'd300:rom_y<=15'd14680;
10'd301:rom_y<=15'd14668;
10'd302:rom_y<=15'd14657;
10'd303:rom_y<=15'd14646;
10'd304:rom_y<=15'd14635;
10'd305:rom_y<=15'd14623;
10'd306:rom_y<=15'd14612;
10'd307:rom_y<=15'd14601;
10'd308:rom_y<=15'd14589;
10'd309:rom_y<=15'd14578;
10'd310:rom_y<=15'd14566;
10'd311:rom_y<=15'd14555;
10'd312:rom_y<=15'd14543;
10'd313:rom_y<=15'd14531;
10'd314:rom_y<=15'd14520;
10'd315:rom_y<=15'd14508;
10'd316:rom_y<=15'd14497;
10'd317:rom_y<=15'd14485;
10'd318:rom_y<=15'd14473;
10'd319:rom_y<=15'd14461;
10'd320:rom_y<=15'd14449;
10'd321:rom_y<=15'd14438;
10'd322:rom_y<=15'd14426;
10'd323:rom_y<=15'd14414;
10'd324:rom_y<=15'd14402;
10'd325:rom_y<=15'd14390;
10'd326:rom_y<=15'd14378;
10'd327:rom_y<=15'd14366;
10'd328:rom_y<=15'd14354;
10'd329:rom_y<=15'd14341;
10'd330:rom_y<=15'd14329;
10'd331:rom_y<=15'd14317;
10'd332:rom_y<=15'd14305;
10'd333:rom_y<=15'd14293;
10'd334:rom_y<=15'd14280;
10'd335:rom_y<=15'd14268;
10'd336:rom_y<=15'd14256;
10'd337:rom_y<=15'd14243;
10'd338:rom_y<=15'd14231;
10'd339:rom_y<=15'd14218;
10'd340:rom_y<=15'd14206;
10'd341:rom_y<=15'd14193;
10'd342:rom_y<=15'd14181;
10'd343:rom_y<=15'd14168;
10'd344:rom_y<=15'd14155;
10'd345:rom_y<=15'd14143;
10'd346:rom_y<=15'd14130;
10'd347:rom_y<=15'd14117;
10'd348:rom_y<=15'd14104;
10'd349:rom_y<=15'd14092;
10'd350:rom_y<=15'd14079;
10'd351:rom_y<=15'd14066;
10'd352:rom_y<=15'd14053;
10'd353:rom_y<=15'd14040;
10'd354:rom_y<=15'd14027;
10'd355:rom_y<=15'd14014;
10'd356:rom_y<=15'd14001;
10'd357:rom_y<=15'd13988;
10'd358:rom_y<=15'd13975;
10'd359:rom_y<=15'd13962;
10'd360:rom_y<=15'd13949;
10'd361:rom_y<=15'd13935;
10'd362:rom_y<=15'd13922;
10'd363:rom_y<=15'd13909;
10'd364:rom_y<=15'd13896;
10'd365:rom_y<=15'd13882;
10'd366:rom_y<=15'd13869;
10'd367:rom_y<=15'd13856;
10'd368:rom_y<=15'd13842;
10'd369:rom_y<=15'd13829;
10'd370:rom_y<=15'd13815;
10'd371:rom_y<=15'd13802;
10'd372:rom_y<=15'd13788;
10'd373:rom_y<=15'd13774;
10'd374:rom_y<=15'd13761;
10'd375:rom_y<=15'd13747;
10'd376:rom_y<=15'd13733;
10'd377:rom_y<=15'd13720;
10'd378:rom_y<=15'd13706;
10'd379:rom_y<=15'd13692;
10'd380:rom_y<=15'd13678;
10'd381:rom_y<=15'd13665;
10'd382:rom_y<=15'd13651;
10'd383:rom_y<=15'd13637;
10'd384:rom_y<=15'd13623;
10'd385:rom_y<=15'd13609;
10'd386:rom_y<=15'd13595;
10'd387:rom_y<=15'd13581;
10'd388:rom_y<=15'd13567;
10'd389:rom_y<=15'd13553;
10'd390:rom_y<=15'd13538;
10'd391:rom_y<=15'd13524;
10'd392:rom_y<=15'd13510;
10'd393:rom_y<=15'd13496;
10'd394:rom_y<=15'd13482;
10'd395:rom_y<=15'd13467;
10'd396:rom_y<=15'd13453;
10'd397:rom_y<=15'd13439;
10'd398:rom_y<=15'd13424;
10'd399:rom_y<=15'd13410;
10'd400:rom_y<=15'd13395;
10'd401:rom_y<=15'd13381;
10'd402:rom_y<=15'd13366;
10'd403:rom_y<=15'd13352;
10'd404:rom_y<=15'd13337;
10'd405:rom_y<=15'd13323;
10'd406:rom_y<=15'd13308;
10'd407:rom_y<=15'd13293;
10'd408:rom_y<=15'd13279;
10'd409:rom_y<=15'd13264;
10'd410:rom_y<=15'd13249;
10'd411:rom_y<=15'd13234;
10'd412:rom_y<=15'd13219;
10'd413:rom_y<=15'd13205;
10'd414:rom_y<=15'd13190;
10'd415:rom_y<=15'd13175;
10'd416:rom_y<=15'd13160;
10'd417:rom_y<=15'd13145;
10'd418:rom_y<=15'd13130;
10'd419:rom_y<=15'd13115;
10'd420:rom_y<=15'd13100;
10'd421:rom_y<=15'd13085;
10'd422:rom_y<=15'd13069;
10'd423:rom_y<=15'd13054;
10'd424:rom_y<=15'd13039;
10'd425:rom_y<=15'd13024;
10'd426:rom_y<=15'd13008;
10'd427:rom_y<=15'd12993;
10'd428:rom_y<=15'd12978;
10'd429:rom_y<=15'd12963;
10'd430:rom_y<=15'd12947;
10'd431:rom_y<=15'd12932;
10'd432:rom_y<=15'd12916;
10'd433:rom_y<=15'd12901;
10'd434:rom_y<=15'd12885;
10'd435:rom_y<=15'd12870;
10'd436:rom_y<=15'd12854;
10'd437:rom_y<=15'd12839;
10'd438:rom_y<=15'd12823;
10'd439:rom_y<=15'd12807;
10'd440:rom_y<=15'd12792;
10'd441:rom_y<=15'd12776;
10'd442:rom_y<=15'd12760;
10'd443:rom_y<=15'd12744;
10'd444:rom_y<=15'd12729;
10'd445:rom_y<=15'd12713;
10'd446:rom_y<=15'd12697;
10'd447:rom_y<=15'd12681;
10'd448:rom_y<=15'd12665;
10'd449:rom_y<=15'd12649;
10'd450:rom_y<=15'd12633;
10'd451:rom_y<=15'd12617;
10'd452:rom_y<=15'd12601;
10'd453:rom_y<=15'd12585;
10'd454:rom_y<=15'd12569;
10'd455:rom_y<=15'd12553;
10'd456:rom_y<=15'd12537;
10'd457:rom_y<=15'd12520;
10'd458:rom_y<=15'd12504;
10'd459:rom_y<=15'd12488;
10'd460:rom_y<=15'd12472;
10'd461:rom_y<=15'd12455;
10'd462:rom_y<=15'd12439;
10'd463:rom_y<=15'd12423;
10'd464:rom_y<=15'd12406;
10'd465:rom_y<=15'd12390;
10'd466:rom_y<=15'd12373;
10'd467:rom_y<=15'd12357;
10'd468:rom_y<=15'd12340;
10'd469:rom_y<=15'd12324;
10'd470:rom_y<=15'd12307;
10'd471:rom_y<=15'd12290;
10'd472:rom_y<=15'd12274;
10'd473:rom_y<=15'd12257;
10'd474:rom_y<=15'd12240;
10'd475:rom_y<=15'd12224;
10'd476:rom_y<=15'd12207;
10'd477:rom_y<=15'd12190;
10'd478:rom_y<=15'd12173;
10'd479:rom_y<=15'd12157;
10'd480:rom_y<=15'd12140;
10'd481:rom_y<=15'd12123;
10'd482:rom_y<=15'd12106;
10'd483:rom_y<=15'd12089;
10'd484:rom_y<=15'd12072;
10'd485:rom_y<=15'd12055;
10'd486:rom_y<=15'd12038;
10'd487:rom_y<=15'd12021;
10'd488:rom_y<=15'd12004;
10'd489:rom_y<=15'd11987;
10'd490:rom_y<=15'd11970;
10'd491:rom_y<=15'd11952;
10'd492:rom_y<=15'd11935;
10'd493:rom_y<=15'd11918;
10'd494:rom_y<=15'd11901;
10'd495:rom_y<=15'd11883;
10'd496:rom_y<=15'd11866;
10'd497:rom_y<=15'd11849;
10'd498:rom_y<=15'd11831;
10'd499:rom_y<=15'd11814;
10'd500:rom_y<=15'd11797;
10'd501:rom_y<=15'd11779;
10'd502:rom_y<=15'd11762;
10'd503:rom_y<=15'd11744;
10'd504:rom_y<=15'd11727;
10'd505:rom_y<=15'd11709;
10'd506:rom_y<=15'd11691;
10'd507:rom_y<=15'd11674;
10'd508:rom_y<=15'd11656;
10'd509:rom_y<=15'd11638;
10'd510:rom_y<=15'd11621;
10'd511:rom_y<=15'd11603;
10'd512:rom_y<=15'd11585;
10'd513:rom_y<=15'd11567;
10'd514:rom_y<=15'd11550;
10'd515:rom_y<=15'd11532;
10'd516:rom_y<=15'd11514;
10'd517:rom_y<=15'd11496;
10'd518:rom_y<=15'd11478;
10'd519:rom_y<=15'd11460;
10'd520:rom_y<=15'd11442;
10'd521:rom_y<=15'd11424;
10'd522:rom_y<=15'd11406;
10'd523:rom_y<=15'd11388;
10'd524:rom_y<=15'd11370;
10'd525:rom_y<=15'd11352;
10'd526:rom_y<=15'd11334;
10'd527:rom_y<=15'd11316;
10'd528:rom_y<=15'd11297;
10'd529:rom_y<=15'd11279;
10'd530:rom_y<=15'd11261;
10'd531:rom_y<=15'd11243;
10'd532:rom_y<=15'd11224;
10'd533:rom_y<=15'd11206;
10'd534:rom_y<=15'd11188;
10'd535:rom_y<=15'd11169;
10'd536:rom_y<=15'd11151;
10'd537:rom_y<=15'd11133;
10'd538:rom_y<=15'd11114;
10'd539:rom_y<=15'd11096;
10'd540:rom_y<=15'd11077;
10'd541:rom_y<=15'd11059;
10'd542:rom_y<=15'd11040;
10'd543:rom_y<=15'd11021;
10'd544:rom_y<=15'd11003;
10'd545:rom_y<=15'd10984;
10'd546:rom_y<=15'd10966;
10'd547:rom_y<=15'd10947;
10'd548:rom_y<=15'd10928;
10'd549:rom_y<=15'd10909;
10'd550:rom_y<=15'd10891;
10'd551:rom_y<=15'd10872;
10'd552:rom_y<=15'd10853;
10'd553:rom_y<=15'd10834;
10'd554:rom_y<=15'd10815;
10'd555:rom_y<=15'd10796;
10'd556:rom_y<=15'd10778;
10'd557:rom_y<=15'd10759;
10'd558:rom_y<=15'd10740;
10'd559:rom_y<=15'd10721;
10'd560:rom_y<=15'd10702;
10'd561:rom_y<=15'd10683;
10'd562:rom_y<=15'd10663;
10'd563:rom_y<=15'd10644;
10'd564:rom_y<=15'd10625;
10'd565:rom_y<=15'd10606;
10'd566:rom_y<=15'd10587;
10'd567:rom_y<=15'd10568;
10'd568:rom_y<=15'd10549;
10'd569:rom_y<=15'd10529;
10'd570:rom_y<=15'd10510;
10'd571:rom_y<=15'd10491;
10'd572:rom_y<=15'd10471;
10'd573:rom_y<=15'd10452;
10'd574:rom_y<=15'd10433;
10'd575:rom_y<=15'd10413;
10'd576:rom_y<=15'd10394;
10'd577:rom_y<=15'd10374;
10'd578:rom_y<=15'd10355;
10'd579:rom_y<=15'd10336;
10'd580:rom_y<=15'd10316;
10'd581:rom_y<=15'd10296;
10'd582:rom_y<=15'd10277;
10'd583:rom_y<=15'd10257;
10'd584:rom_y<=15'd10238;
10'd585:rom_y<=15'd10218;
10'd586:rom_y<=15'd10198;
10'd587:rom_y<=15'd10179;
10'd588:rom_y<=15'd10159;
10'd589:rom_y<=15'd10139;
10'd590:rom_y<=15'd10120;
10'd591:rom_y<=15'd10100;
10'd592:rom_y<=15'd10080;
10'd593:rom_y<=15'd10060;
10'd594:rom_y<=15'd10040;
10'd595:rom_y<=15'd10020;
10'd596:rom_y<=15'd10001;
10'd597:rom_y<=15'd9981;
10'd598:rom_y<=15'd9961;
10'd599:rom_y<=15'd9941;
10'd600:rom_y<=15'd9921;
10'd601:rom_y<=15'd9901;
10'd602:rom_y<=15'd9881;
10'd603:rom_y<=15'd9861;
10'd604:rom_y<=15'd9841;
10'd605:rom_y<=15'd9820;
10'd606:rom_y<=15'd9800;
10'd607:rom_y<=15'd9780;
10'd608:rom_y<=15'd9760;
10'd609:rom_y<=15'd9740;
10'd610:rom_y<=15'd9720;
10'd611:rom_y<=15'd9699;
10'd612:rom_y<=15'd9679;
10'd613:rom_y<=15'd9659;
10'd614:rom_y<=15'd9638;
10'd615:rom_y<=15'd9618;
10'd616:rom_y<=15'd9598;
10'd617:rom_y<=15'd9577;
10'd618:rom_y<=15'd9557;
10'd619:rom_y<=15'd9537;
10'd620:rom_y<=15'd9516;
10'd621:rom_y<=15'd9496;
10'd622:rom_y<=15'd9475;
10'd623:rom_y<=15'd9455;
10'd624:rom_y<=15'd9434;
10'd625:rom_y<=15'd9413;
10'd626:rom_y<=15'd9393;
10'd627:rom_y<=15'd9372;
10'd628:rom_y<=15'd9352;
10'd629:rom_y<=15'd9331;
10'd630:rom_y<=15'd9310;
10'd631:rom_y<=15'd9290;
10'd632:rom_y<=15'd9269;
10'd633:rom_y<=15'd9248;
10'd634:rom_y<=15'd9227;
10'd635:rom_y<=15'd9207;
10'd636:rom_y<=15'd9186;
10'd637:rom_y<=15'd9165;
10'd638:rom_y<=15'd9144;
10'd639:rom_y<=15'd9123;
10'd640:rom_y<=15'd9102;
10'd641:rom_y<=15'd9082;
10'd642:rom_y<=15'd9061;
10'd643:rom_y<=15'd9040;
10'd644:rom_y<=15'd9019;
10'd645:rom_y<=15'd8998;
10'd646:rom_y<=15'd8977;
10'd647:rom_y<=15'd8956;
10'd648:rom_y<=15'd8935;
10'd649:rom_y<=15'd8914;
10'd650:rom_y<=15'd8892;
10'd651:rom_y<=15'd8871;
10'd652:rom_y<=15'd8850;
10'd653:rom_y<=15'd8829;
10'd654:rom_y<=15'd8808;
10'd655:rom_y<=15'd8787;
10'd656:rom_y<=15'd8765;
10'd657:rom_y<=15'd8744;
10'd658:rom_y<=15'd8723;
10'd659:rom_y<=15'd8702;
10'd660:rom_y<=15'd8680;
10'd661:rom_y<=15'd8659;
10'd662:rom_y<=15'd8638;
10'd663:rom_y<=15'd8616;
10'd664:rom_y<=15'd8595;
10'd665:rom_y<=15'd8573;
10'd666:rom_y<=15'd8552;
10'd667:rom_y<=15'd8531;
10'd668:rom_y<=15'd8509;
10'd669:rom_y<=15'd8488;
10'd670:rom_y<=15'd8466;
10'd671:rom_y<=15'd8445;
10'd672:rom_y<=15'd8423;
10'd673:rom_y<=15'd8401;
10'd674:rom_y<=15'd8380;
10'd675:rom_y<=15'd8358;
10'd676:rom_y<=15'd8337;
10'd677:rom_y<=15'd8315;
10'd678:rom_y<=15'd8293;
10'd679:rom_y<=15'd8272;
10'd680:rom_y<=15'd8250;
10'd681:rom_y<=15'd8228;
10'd682:rom_y<=15'd8207;
10'd683:rom_y<=15'd8185;
10'd684:rom_y<=15'd8163;
10'd685:rom_y<=15'd8141;
10'd686:rom_y<=15'd8119;
10'd687:rom_y<=15'd8098;
10'd688:rom_y<=15'd8076;
10'd689:rom_y<=15'd8054;
10'd690:rom_y<=15'd8032;
10'd691:rom_y<=15'd8010;
10'd692:rom_y<=15'd7988;
10'd693:rom_y<=15'd7966;
10'd694:rom_y<=15'd7944;
10'd695:rom_y<=15'd7922;
10'd696:rom_y<=15'd7900;
10'd697:rom_y<=15'd7878;
10'd698:rom_y<=15'd7856;
10'd699:rom_y<=15'd7834;
10'd700:rom_y<=15'd7812;
10'd701:rom_y<=15'd7790;
10'd702:rom_y<=15'd7768;
10'd703:rom_y<=15'd7746;
10'd704:rom_y<=15'd7723;
10'd705:rom_y<=15'd7701;
10'd706:rom_y<=15'd7679;
10'd707:rom_y<=15'd7657;
10'd708:rom_y<=15'd7635;
10'd709:rom_y<=15'd7612;
10'd710:rom_y<=15'd7590;
10'd711:rom_y<=15'd7568;
10'd712:rom_y<=15'd7545;
10'd713:rom_y<=15'd7523;
10'd714:rom_y<=15'd7501;
10'd715:rom_y<=15'd7478;
10'd716:rom_y<=15'd7456;
10'd717:rom_y<=15'd7434;
10'd718:rom_y<=15'd7411;
10'd719:rom_y<=15'd7389;
10'd720:rom_y<=15'd7366;
10'd721:rom_y<=15'd7344;
10'd722:rom_y<=15'd7321;
10'd723:rom_y<=15'd7299;
10'd724:rom_y<=15'd7276;
10'd725:rom_y<=15'd7254;
10'd726:rom_y<=15'd7231;
10'd727:rom_y<=15'd7209;
10'd728:rom_y<=15'd7186;
10'd729:rom_y<=15'd7164;
10'd730:rom_y<=15'd7141;
10'd731:rom_y<=15'd7118;
10'd732:rom_y<=15'd7096;
10'd733:rom_y<=15'd7073;
10'd734:rom_y<=15'd7050;
10'd735:rom_y<=15'd7028;
10'd736:rom_y<=15'd7005;
10'd737:rom_y<=15'd6982;
10'd738:rom_y<=15'd6960;
10'd739:rom_y<=15'd6937;
10'd740:rom_y<=15'd6914;
10'd741:rom_y<=15'd6891;
10'd742:rom_y<=15'd6868;
10'd743:rom_y<=15'd6846;
10'd744:rom_y<=15'd6823;
10'd745:rom_y<=15'd6800;
10'd746:rom_y<=15'd6777;
10'd747:rom_y<=15'd6754;
10'd748:rom_y<=15'd6731;
10'd749:rom_y<=15'd6708;
10'd750:rom_y<=15'd6685;
10'd751:rom_y<=15'd6662;
10'd752:rom_y<=15'd6639;
10'd753:rom_y<=15'd6616;
10'd754:rom_y<=15'd6593;
10'd755:rom_y<=15'd6570;
10'd756:rom_y<=15'd6547;
10'd757:rom_y<=15'd6524;
10'd758:rom_y<=15'd6501;
10'd759:rom_y<=15'd6478;
10'd760:rom_y<=15'd6455;
10'd761:rom_y<=15'd6432;
10'd762:rom_y<=15'd6409;
10'd763:rom_y<=15'd6386;
10'd764:rom_y<=15'd6363;
10'd765:rom_y<=15'd6339;
10'd766:rom_y<=15'd6316;
10'd767:rom_y<=15'd6293;
10'd768:rom_y<=15'd6270;
10'd769:rom_y<=15'd6247;
10'd770:rom_y<=15'd6223;
10'd771:rom_y<=15'd6200;
10'd772:rom_y<=15'd6177;
10'd773:rom_y<=15'd6154;
10'd774:rom_y<=15'd6130;
10'd775:rom_y<=15'd6107;
10'd776:rom_y<=15'd6084;
10'd777:rom_y<=15'd6060;
10'd778:rom_y<=15'd6037;
10'd779:rom_y<=15'd6014;
10'd780:rom_y<=15'd5990;
10'd781:rom_y<=15'd5967;
10'd782:rom_y<=15'd5943;
10'd783:rom_y<=15'd5920;
10'd784:rom_y<=15'd5897;
10'd785:rom_y<=15'd5873;
10'd786:rom_y<=15'd5850;
10'd787:rom_y<=15'd5826;
10'd788:rom_y<=15'd5803;
10'd789:rom_y<=15'd5779;
10'd790:rom_y<=15'd5756;
10'd791:rom_y<=15'd5732;
10'd792:rom_y<=15'd5708;
10'd793:rom_y<=15'd5685;
10'd794:rom_y<=15'd5661;
10'd795:rom_y<=15'd5638;
10'd796:rom_y<=15'd5614;
10'd797:rom_y<=15'd5591;
10'd798:rom_y<=15'd5567;
10'd799:rom_y<=15'd5543;
10'd800:rom_y<=15'd5520;
10'd801:rom_y<=15'd5496;
10'd802:rom_y<=15'd5472;
10'd803:rom_y<=15'd5449;
10'd804:rom_y<=15'd5425;
10'd805:rom_y<=15'd5401;
10'd806:rom_y<=15'd5377;
10'd807:rom_y<=15'd5354;
10'd808:rom_y<=15'd5330;
10'd809:rom_y<=15'd5306;
10'd810:rom_y<=15'd5282;
10'd811:rom_y<=15'd5259;
10'd812:rom_y<=15'd5235;
10'd813:rom_y<=15'd5211;
10'd814:rom_y<=15'd5187;
10'd815:rom_y<=15'd5163;
10'd816:rom_y<=15'd5139;
10'd817:rom_y<=15'd5115;
10'd818:rom_y<=15'd5092;
10'd819:rom_y<=15'd5068;
10'd820:rom_y<=15'd5044;
10'd821:rom_y<=15'd5020;
10'd822:rom_y<=15'd4996;
10'd823:rom_y<=15'd4972;
10'd824:rom_y<=15'd4948;
10'd825:rom_y<=15'd4924;
10'd826:rom_y<=15'd4900;
10'd827:rom_y<=15'd4876;
10'd828:rom_y<=15'd4852;
10'd829:rom_y<=15'd4828;
10'd830:rom_y<=15'd4804;
10'd831:rom_y<=15'd4780;
10'd832:rom_y<=15'd4756;
10'd833:rom_y<=15'd4732;
10'd834:rom_y<=15'd4708;
10'd835:rom_y<=15'd4684;
10'd836:rom_y<=15'd4660;
10'd837:rom_y<=15'd4636;
10'd838:rom_y<=15'd4612;
10'd839:rom_y<=15'd4587;
10'd840:rom_y<=15'd4563;
10'd841:rom_y<=15'd4539;
10'd842:rom_y<=15'd4515;
10'd843:rom_y<=15'd4491;
10'd844:rom_y<=15'd4467;
10'd845:rom_y<=15'd4442;
10'd846:rom_y<=15'd4418;
10'd847:rom_y<=15'd4394;
10'd848:rom_y<=15'd4370;
10'd849:rom_y<=15'd4346;
10'd850:rom_y<=15'd4321;
10'd851:rom_y<=15'd4297;
10'd852:rom_y<=15'd4273;
10'd853:rom_y<=15'd4249;
10'd854:rom_y<=15'd4224;
10'd855:rom_y<=15'd4200;
10'd856:rom_y<=15'd4176;
10'd857:rom_y<=15'd4151;
10'd858:rom_y<=15'd4127;
10'd859:rom_y<=15'd4103;
10'd860:rom_y<=15'd4078;
10'd861:rom_y<=15'd4054;
10'd862:rom_y<=15'd4030;
10'd863:rom_y<=15'd4005;
10'd864:rom_y<=15'd3981;
10'd865:rom_y<=15'd3957;
10'd866:rom_y<=15'd3932;
10'd867:rom_y<=15'd3908;
10'd868:rom_y<=15'd3883;
10'd869:rom_y<=15'd3859;
10'd870:rom_y<=15'd3835;
10'd871:rom_y<=15'd3810;
10'd872:rom_y<=15'd3786;
10'd873:rom_y<=15'd3761;
10'd874:rom_y<=15'd3737;
10'd875:rom_y<=15'd3712;
10'd876:rom_y<=15'd3688;
10'd877:rom_y<=15'd3663;
10'd878:rom_y<=15'd3639;
10'd879:rom_y<=15'd3614;
10'd880:rom_y<=15'd3590;
10'd881:rom_y<=15'd3565;
10'd882:rom_y<=15'd3541;
10'd883:rom_y<=15'd3516;
10'd884:rom_y<=15'd3492;
10'd885:rom_y<=15'd3467;
10'd886:rom_y<=15'd3442;
10'd887:rom_y<=15'd3418;
10'd888:rom_y<=15'd3393;
10'd889:rom_y<=15'd3369;
10'd890:rom_y<=15'd3344;
10'd891:rom_y<=15'd3320;
10'd892:rom_y<=15'd3295;
10'd893:rom_y<=15'd3270;
10'd894:rom_y<=15'd3246;
10'd895:rom_y<=15'd3221;
10'd896:rom_y<=15'd3196;
10'd897:rom_y<=15'd3172;
10'd898:rom_y<=15'd3147;
10'd899:rom_y<=15'd3122;
10'd900:rom_y<=15'd3098;
10'd901:rom_y<=15'd3073;
10'd902:rom_y<=15'd3048;
10'd903:rom_y<=15'd3024;
10'd904:rom_y<=15'd2999;
10'd905:rom_y<=15'd2974;
10'd906:rom_y<=15'd2949;
10'd907:rom_y<=15'd2925;
10'd908:rom_y<=15'd2900;
10'd909:rom_y<=15'd2875;
10'd910:rom_y<=15'd2851;
10'd911:rom_y<=15'd2826;
10'd912:rom_y<=15'd2801;
10'd913:rom_y<=15'd2776;
10'd914:rom_y<=15'd2752;
10'd915:rom_y<=15'd2727;
10'd916:rom_y<=15'd2702;
10'd917:rom_y<=15'd2677;
10'd918:rom_y<=15'd2652;
10'd919:rom_y<=15'd2628;
10'd920:rom_y<=15'd2603;
10'd921:rom_y<=15'd2578;
10'd922:rom_y<=15'd2553;
10'd923:rom_y<=15'd2528;
10'd924:rom_y<=15'd2503;
10'd925:rom_y<=15'd2479;
10'd926:rom_y<=15'd2454;
10'd927:rom_y<=15'd2429;
10'd928:rom_y<=15'd2404;
10'd929:rom_y<=15'd2379;
10'd930:rom_y<=15'd2354;
10'd931:rom_y<=15'd2329;
10'd932:rom_y<=15'd2305;
10'd933:rom_y<=15'd2280;
10'd934:rom_y<=15'd2255;
10'd935:rom_y<=15'd2230;
10'd936:rom_y<=15'd2205;
10'd937:rom_y<=15'd2180;
10'd938:rom_y<=15'd2155;
10'd939:rom_y<=15'd2130;
10'd940:rom_y<=15'd2105;
10'd941:rom_y<=15'd2080;
10'd942:rom_y<=15'd2055;
10'd943:rom_y<=15'd2031;
10'd944:rom_y<=15'd2006;
10'd945:rom_y<=15'd1981;
10'd946:rom_y<=15'd1956;
10'd947:rom_y<=15'd1931;
10'd948:rom_y<=15'd1906;
10'd949:rom_y<=15'd1881;
10'd950:rom_y<=15'd1856;
10'd951:rom_y<=15'd1831;
10'd952:rom_y<=15'd1806;
10'd953:rom_y<=15'd1781;
10'd954:rom_y<=15'd1756;
10'd955:rom_y<=15'd1731;
10'd956:rom_y<=15'd1706;
10'd957:rom_y<=15'd1681;
10'd958:rom_y<=15'd1656;
10'd959:rom_y<=15'd1631;
10'd960:rom_y<=15'd1606;
10'd961:rom_y<=15'd1581;
10'd962:rom_y<=15'd1556;
10'd963:rom_y<=15'd1531;
10'd964:rom_y<=15'd1506;
10'd965:rom_y<=15'd1481;
10'd966:rom_y<=15'd1456;
10'd967:rom_y<=15'd1431;
10'd968:rom_y<=15'd1406;
10'd969:rom_y<=15'd1381;
10'd970:rom_y<=15'd1356;
10'd971:rom_y<=15'd1331;
10'd972:rom_y<=15'd1306;
10'd973:rom_y<=15'd1280;
10'd974:rom_y<=15'd1255;
10'd975:rom_y<=15'd1230;
10'd976:rom_y<=15'd1205;
10'd977:rom_y<=15'd1180;
10'd978:rom_y<=15'd1155;
10'd979:rom_y<=15'd1130;
10'd980:rom_y<=15'd1105;
10'd981:rom_y<=15'd1080;
10'd982:rom_y<=15'd1055;
10'd983:rom_y<=15'd1030;
10'd984:rom_y<=15'd1005;
10'd985:rom_y<=15'd980;
10'd986:rom_y<=15'd955;
10'd987:rom_y<=15'd929;
10'd988:rom_y<=15'd904;
10'd989:rom_y<=15'd879;
10'd990:rom_y<=15'd854;
10'd991:rom_y<=15'd829;
10'd992:rom_y<=15'd804;
10'd993:rom_y<=15'd779;
10'd994:rom_y<=15'd754;
10'd995:rom_y<=15'd729;
10'd996:rom_y<=15'd704;
10'd997:rom_y<=15'd678;
10'd998:rom_y<=15'd653;
10'd999:rom_y<=15'd628;
10'd1000:rom_y<=15'd603;
10'd1001:rom_y<=15'd578;
10'd1002:rom_y<=15'd553;
10'd1003:rom_y<=15'd528;
10'd1004:rom_y<=15'd503;
10'd1005:rom_y<=15'd477;
10'd1006:rom_y<=15'd452;
10'd1007:rom_y<=15'd427;
10'd1008:rom_y<=15'd402;
10'd1009:rom_y<=15'd377;
10'd1010:rom_y<=15'd352;
10'd1011:rom_y<=15'd327;
10'd1012:rom_y<=15'd302;
10'd1013:rom_y<=15'd276;
10'd1014:rom_y<=15'd251;
10'd1015:rom_y<=15'd226;
10'd1016:rom_y<=15'd201;
10'd1017:rom_y<=15'd176;
10'd1018:rom_y<=15'd151;
10'd1019:rom_y<=15'd126;
10'd1020:rom_y<=15'd101;
10'd1021:rom_y<=15'd75;
10'd1022:rom_y<=15'd50;
10'd1023:rom_y<=15'd25;
endcase
endmodule