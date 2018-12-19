    [hair_id1, Pprs1] = trichrome(image, bw_label, 1);
    [tri(1), n1] = size(hair_id1);
    [hair_id2, Pprs2] = trichrome(image, bw_label, 2);
    [tri(2), n1] = size(hair_id2);
    [hair_id3, Pprs3] = trichrome(image, bw_label, 3);
    [tri(3), n1] = size(hair_id3);
    [hair_id4, Pprs4] = trichrome(image, bw_label, 4)
    [tri(4), n1] = size(hair_id4);
    [hair_id5, Pprs5] = trichrome(image, bw_label, 5);
    [tri(5), n1] = size(hair_id5);
    [hair_id6, Pprs6] = trichrome(image, bw_label, 6);
    [tri(6), n1] = size(hair_id6);
    [hair_id7, Pprs7] = trichrome(image, bw_label, 7);
    [tri(7), n1] = size(hair_id7);

     s = regionprops(bw_label,'Area');

    areas = cat(1, s.Area);
    areas = areas';